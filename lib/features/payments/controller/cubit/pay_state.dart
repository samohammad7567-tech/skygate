part of 'pay_cubit.dart';

@immutable
sealed class PayState {}

final class PayInitial extends PayState {}

// ── طريقة التحويل ──────────────────────────────────────────────────────────
final class PayMethodsLoading extends PayState {}

final class PayMethodsLoaded extends PayState {}

final class PayMethodsError extends PayState {
  PayMethodsError({required this.message});

  final String message;
}

final class PayFormChanged extends PayState {}

final class PayReceiptTooLarge extends PayState {}

// ── ارسال ──────────────────────────────────────────────────────────────────
final class PaySubmitLoading extends PayState {}

final class PaySubmitted extends PayState {
  PaySubmitted({required this.transaction});

  final FinancialTransactionModel transaction;
}

final class PaySubmitError extends PayState {
  PaySubmitError({required this.message});

  final String message;
}
