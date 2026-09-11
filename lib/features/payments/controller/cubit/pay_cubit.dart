import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';
import 'package:skygate/features/payments/models/payment_currency.dart';
import 'package:skygate/features/payments/models/payment_method_model.dart';

part 'pay_state.dart';

class PayCubit extends Cubit<PayState> {
  PayCubit(this.bookingId) : super(PayInitial());

  PayCubit get(BuildContext context) => BlocProvider.of(context);

  final int bookingId;
  static const int maxReceiptBytes = 2 * 1024 * 1024;

  // ── طريقة التحويل ────────────────────────────────────────────────────────
  List<PaymentMethodModel> methods = const [];
  PaymentMethodModel? selectedMethod;

  Future<void> getMethods() async {
    emit(PayMethodsLoading());
    try {
      final response = await DioService.get(ApiEndpoints.paymentMethods);
      // `data` is the `{ "items": [...] }` envelope here, not the bare array
      // the document shows — [ApiParse.rowsOf] reads either shape.
      methods = ApiParse.rowsOf(
        response.data['data'],
        PaymentMethodModel.fromJson,
      ).where((method) => method.isActive).toList();

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
      print('submit payment body: $body["data"]["id"]');
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
