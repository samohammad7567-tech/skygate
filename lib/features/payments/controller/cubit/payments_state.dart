part of 'payments_cubit.dart';

@immutable
sealed class PaymentsState {}

final class PaymentsInitial extends PaymentsState {}

// ── ملخص المدفوعات ─────────────────────────────────────────────────────────
final class PaymentSummaryLoading extends PaymentsState {}

final class PaymentSummaryLoaded extends PaymentsState {}

final class PaymentSummaryError extends PaymentsState {
  PaymentSummaryError({required this.message});

  final String message;
}

// ── المعاملات المالية ──────────────────────────────────────────────────────
final class TransactionsLoading extends PaymentsState {}

final class TransactionsLoaded extends PaymentsState {}

final class TransactionsError extends PaymentsState {
  TransactionsError({required this.message});

  final String message;
}
