import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';
import 'package:skygate/features/payments/models/payment_currency.dart';
import 'package:skygate/features/payments/models/payment_method_model.dart';

part 'pay_state.dart';

/// "معلومات الدفع" — the sheet "ادفع الآن" opens.
///
/// It collects the four things `POST app/financial-transactions` takes — the
/// currency the payer transferred in, how much, through which method, and a
/// photo of the receipt — and posts them as one multipart request.
class PayCubit extends Cubit<PayState> {
  PayCubit(this.bookingId) : super(PayInitial());

  PayCubit get(BuildContext context) => BlocProvider.of(context);

  final int bookingId;

  /// Ceiling the API puts on `receipt`: "Must not be greater than 2048
  /// kilobytes". Tighter than [ImagePickerService.maxSizeInBytes], which the
  /// pilgrim documents go by.
  static const int maxReceiptBytes = 2 * 1024 * 1024;

  // ── طريقة التحويل ────────────────────────────────────────────────────────
  List<PaymentMethodModel> methods = const [];

  /// The method the radio column has selected.
  PaymentMethodModel? selectedMethod;

  Future<void> getMethods() async {
    emit(PayMethodsLoading());
    try {
      final response = await DioService.get(ApiEndpoints.paymentMethods);
      final body = response.data['data'];
      methods = [
        if (body is List)
          for (final item in body)
            if (item is Map<String, dynamic>) PaymentMethodModel.fromJson(item),
      ].where((method) => method.isActive).toList();

      // Keep whatever was already picked; otherwise leave the column empty so
      // the payer makes the choice themselves.
      final chosen = selectedMethod?.id;
      selectedMethod = null;
      for (final method in methods) {
        if (method.id == chosen) {
          selectedMethod = method;
          break;
        }
      }
      emit(PayMethodsLoaded());
    } catch (error) {
      debugPrint('getMethods error: $error');
      emit(PayMethodsError(message: ApiError.messageOf(error)));
    }
  }

  void selectMethod(PaymentMethodModel method) {
    if (selectedMethod?.id == method.id) return;
    selectedMethod = method;
    emit(PayFormChanged());
  }

  // ── نوع المبلغ المحول ────────────────────────────────────────────────────
  PaymentCurrency currency = PaymentCurrency.usd;

  void changeCurrency(PaymentCurrency value) {
    if (currency == value) return;
    currency = value;
    emit(PayFormChanged());
  }

  // ── صورة إيصال الحوالة ───────────────────────────────────────────────────
  File? receipt;

  Future<void> pickReceipt(ImageSource source) async {
    final picked = await ImagePickerService.pick(source);
    if (picked == null) return;

    if (await picked.length() > maxReceiptBytes) {
      emit(PayReceiptTooLarge());
      emit(PayFormChanged());
      return;
    }

    receipt = picked;
    emit(PayFormChanged());
  }

  void removeReceipt() {
    receipt = null;
    emit(PayFormChanged());
  }

  // ── ارسال ────────────────────────────────────────────────────────────────
  /// `true` once the sheet has everything the endpoint requires.
  bool get canSubmit => selectedMethod?.id != null;

  Future<void> submit({required String amount, String? referenceNumber}) async {
    final method = selectedMethod?.id;
    final value = num.tryParse(amount.trim());
    if (method == null || value == null || value <= 0) return;

    emit(PaySubmitLoading());
    try {
      final file = receipt;
      final form = FormData.fromMap({
        'booking_id': bookingId,
        'payment_method_id': method,
        'amount': value,
        'currency': currency.code,
        if (referenceNumber != null && referenceNumber.trim().isNotEmpty)
          'reference_number': referenceNumber.trim(),
        if (file != null) 'receipt': await MultipartFile.fromFile(file.path),
      });

      final response = await DioService.post(
        ApiEndpoints.financialTransactions,
        data: form,
      );
      final body = response.data['data'];
      emit(
        PaySubmitted(
          transaction: FinancialTransactionModel.fromJson(
            body is Map<String, dynamic> ? body : const {},
          ),
        ),
      );
    } catch (error) {
      debugPrint('submit payment error: $error');
      emit(PaySubmitError(message: ApiError.messageOf(error)));
    }
  }
}
