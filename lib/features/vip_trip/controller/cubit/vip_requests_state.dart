part of 'vip_requests_cubit.dart';

@immutable
sealed class VipRequestsState {}

final class VipRequestsInitial extends VipRequestsState {}

final class VipRequestsLoading extends VipRequestsState {}

final class VipRequestsLoaded extends VipRequestsState {}

final class VipRequestsError extends VipRequestsState {
  final String message;

  VipRequestsError({required this.message});
}

final class VipRequestLoading extends VipRequestsState {}

final class VipRequestLoaded extends VipRequestsState {}

final class VipRequestError extends VipRequestsState {
  final String message;

  VipRequestError({required this.message});
}

final class VipCancelLoading extends VipRequestsState {}

final class VipCancelled extends VipRequestsState {}

final class VipCancelError extends VipRequestsState {
  final String message;

  VipCancelError({required this.message});
}
