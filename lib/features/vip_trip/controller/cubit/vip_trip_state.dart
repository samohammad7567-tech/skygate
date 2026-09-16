part of 'vip_trip_cubit.dart';

@immutable
sealed class VipTripState {}

final class VipTripInitial extends VipTripState {}

final class VipStepChanged extends VipTripState {}

final class VipDraftChanged extends VipTripState {}

final class VipHotelsLoading extends VipTripState {}

final class VipHotelsLoaded extends VipTripState {}

final class VipHotelsError extends VipTripState {
  final String message;

  VipHotelsError({required this.message});
}

final class VipSubmitLoading extends VipTripState {}

final class VipSubmitted extends VipTripState {}

final class VipSubmitError extends VipTripState {
  final String message;

  VipSubmitError({required this.message});
}
