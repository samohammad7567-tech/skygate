import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';
import 'package:skygate/features/payments/models/booking_payment_model.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit({required this.bookingId, this.details})
    : super(PaymentsInitial());

  PaymentsCubit get(BuildContext context) => BlocProvider.of(context);

  final int bookingId;
  final BookingDetailsModel? details;
  BookingPaymentModel? payment;

  Future<void> getPayment() async {
    emit(PaymentSummaryLoading());
    try {
      final response = await DioService.get(ApiEndpoints.booking(bookingId));
      final body = response.data['data'];
      payment = BookingPaymentModel.fromJson(
        body is Map<String, dynamic> ? body : const {},
      );
      emit(PaymentSummaryLoaded());
    } catch (error) {
      debugPrint('getPayment error: $error');
      emit(PaymentSummaryError(message: ApiError.messageOf(error)));
    }
  }

  List<FinancialTransactionModel> transactions = const [];
  Future<void> getTransactions() async {
    emit(TransactionsLoading());
    emit(TransactionsLoaded());
  }

  void addTransaction(FinancialTransactionModel transaction) {
    transactions = [transaction, ...transactions];
    emit(TransactionsLoaded());
    getPayment();
  }
}
