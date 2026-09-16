part of 'group_booking_cubit.dart';

@immutable
sealed class GroupBookingState {}

final class GroupBookingInitial extends GroupBookingState {}

final class GroupStepChanged extends GroupBookingState {}

final class GroupPassportFieldChanged extends GroupBookingState {}

final class GroupPassportScanLoading extends GroupBookingState {}

final class GroupPassportScanCancelled extends GroupBookingState {}

final class GroupPassportScanned extends GroupBookingState {}

final class GroupPassportScanError extends GroupBookingState {
  final String message;

  GroupPassportScanError({required this.message});
}

final class GroupDocumentPicked extends GroupBookingState {}

final class GroupFileTooLarge extends GroupBookingState {}

final class GroupTravelersChanged extends GroupBookingState {}

final class GroupRoutesLoading extends GroupBookingState {}

final class GroupRoutesLoaded extends GroupBookingState {}

final class GroupRoutesError extends GroupBookingState {
  final String message;

  GroupRoutesError({required this.message});
}

final class GroupRoomPricesLoading extends GroupBookingState {}

final class GroupRoomPricesLoaded extends GroupBookingState {}

final class GroupRoomPricesError extends GroupBookingState {
  final String message;

  GroupRoomPricesError({required this.message});
}

final class GroupRoomsChanged extends GroupBookingState {}

final class GroupHotelsLoading extends GroupBookingState {}

final class GroupHotelsLoaded extends GroupBookingState {}

final class GroupHotelsError extends GroupBookingState {
  final String message;

  GroupHotelsError({required this.message});
}

final class GroupSummaryLoading extends GroupBookingState {}

final class GroupSummaryLoaded extends GroupBookingState {}

final class GroupCountdownTicked extends GroupBookingState {}

final class GroupSummaryError extends GroupBookingState {
  final String message;

  GroupSummaryError({required this.message});
}

final class GroupSubmitLoading extends GroupBookingState {}

final class GroupSubmitted extends GroupBookingState {}

final class GroupSubmitError extends GroupBookingState {
  final String message;

  GroupSubmitError({required this.message});
}
