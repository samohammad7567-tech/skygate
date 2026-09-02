import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';
import 'package:skygate/features/payments/models/booking_payment_model.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';

part 'payments_state.dart';

/// Owns "المدفوعات" and "المعاملات المالية", which are two views of one
/// booking: they print the same summary ring and differ only in what they list
/// underneath, so the transactions screen is pushed with this same cubit
/// rather than fetching the booking a second time.
class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit({required this.bookingId, this.details})
    : super(PaymentsInitial());

  PaymentsCubit get(BuildContext context) => BlocProvider.of(context);

  final int bookingId;

  /// "تفاصيل الحجز", handed in by whoever opened the flow.
  ///
  /// `GET app/bookings/{id}` publishes no rooms, hotels or travellers, so the
  /// screen cannot fetch this — the booking wizards and "رحلاتي" pass what
  /// they already hold. Null hides the "عرض تفاصيل الحجز" button.
  final BookingDetailsModel? details;

  // ── Summary ────────────────────────────────────────────────────────────
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

  // ── Transactions ───────────────────────────────────────────────────────
  /// Every transfer submitted against this booking, newest first.
  List<FinancialTransactionModel> transactions = const [];

  /// Loads "المعاملات المالية".
  ///
  /// The OpenAPI document publishes `POST app/financial-transactions` but no
  /// list beside it, so there is nothing to fetch: the screen shows the
  /// transfers this session created and an empty state otherwise. Point this
  /// at `GET app/financial-transactions?booking_id=` when it lands — the row
  /// model already parses `FinancialTransactionResource`.
  Future<void> getTransactions() async {
    emit(TransactionsLoading());
    emit(TransactionsLoaded());
  }

  /// Files a transfer the payment sheet just created, so both screens show it
  /// without another round trip.
  void addTransaction(FinancialTransactionModel transaction) {
    transactions = [transaction, ...transactions];
    emit(TransactionsLoaded());
    // A confirmed transfer moves the ring; a pending one does not, but the
    // backend is the only place that decides which, so re-read the booking.
    getPayment();
  }
}
