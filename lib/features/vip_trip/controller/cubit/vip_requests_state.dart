part of 'vip_requests_cubit.dart';

@immutable
sealed class VipRequestsState {}

final class VipRequestsInitial extends VipRequestsState {}

// ── GET app/private-trip-requests ──────────────────────────────────────────
final class VipRequestsLoading extends VipRequestsState {}

final class VipRequestsLoaded extends VipRequestsState {}

final class VipRequestsError extends VipRequestsState {
  final String message;

  VipRequestsError({required this.message});
}

// ── GET app/private-trip-requests/{id} ─────────────────────────────────────
final class VipRequestLoading extends VipRequestsState {}

final class VipRequestLoaded extends VipRequestsState {}

final class VipRequestError extends VipRequestsState {
  final String message;

  VipRequestError({required this.message});
}

// ── POST app/private-trip-requests/{id}/cancel ─────────────────────────────
final class VipCancelLoading extends VipRequestsState {}

final class VipCancelled extends VipRequestsState {}

final class VipCancelError extends VipRequestsState {
  final String message;

  VipCancelError({required this.message});
}
