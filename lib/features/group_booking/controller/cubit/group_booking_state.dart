part of 'group_booking_cubit.dart';

@immutable
sealed class GroupBookingState {}

final class GroupBookingInitial extends GroupBookingState {}

/// The wizard moved between steps.
final class GroupStepChanged extends GroupBookingState {}

// ── Passport of the traveller being added ─────────────────────────────────
final class GroupPassportFieldChanged extends GroupBookingState {}

final class GroupPassportScanLoading extends GroupBookingState {}

/// The user dismissed the camera / gallery picker without choosing a file.
final class GroupPassportScanCancelled extends GroupBookingState {}

final class GroupPassportScanned extends GroupBookingState {}

final class GroupPassportScanError extends GroupBookingState {
  final String message;

  GroupPassportScanError({required this.message});
}

// ── Documents ─────────────────────────────────────────────────────────────
final class GroupDocumentPicked extends GroupBookingState {}

/// The picked file is over `ImagePickerService.maxSizeInBytes`.
final class GroupFileTooLarge extends GroupBookingState {}

// ── Group composition ─────────────────────────────────────────────────────
final class GroupTravelersChanged extends GroupBookingState {}

// ── Routes ────────────────────────────────────────────────────────────────
final class GroupRoutesLoading extends GroupBookingState {}

final class GroupRoutesLoaded extends GroupBookingState {}

final class GroupRoutesError extends GroupBookingState {
  final String message;

  GroupRoutesError({required this.message});
}

// ── Rooms ─────────────────────────────────────────────────────────────────
final class GroupRoomPricesLoading extends GroupBookingState {}

final class GroupRoomPricesLoaded extends GroupBookingState {}

final class GroupRoomPricesError extends GroupBookingState {
  final String message;

  GroupRoomPricesError({required this.message});
}

/// A room was created, removed, filled or had its spare beds locked.
final class GroupRoomsChanged extends GroupBookingState {}

// ── Hotels ────────────────────────────────────────────────────────────────
final class GroupHotelsLoading extends GroupBookingState {}

final class GroupHotelsLoaded extends GroupBookingState {}

final class GroupHotelsError extends GroupBookingState {
  final String message;

  GroupHotelsError({required this.message});
}

// ── Summary ───────────────────────────────────────────────────────────────
final class GroupSummaryLoading extends GroupBookingState {}

final class GroupSummaryLoaded extends GroupBookingState {}

/// One tick of the "أكمل الدفع خلال" countdown.
final class GroupCountdownTicked extends GroupBookingState {}

final class GroupSummaryError extends GroupBookingState {
  final String message;

  GroupSummaryError({required this.message});
}

// ── Submit ────────────────────────────────────────────────────────────────
final class GroupSubmitLoading extends GroupBookingState {}

final class GroupSubmitted extends GroupBookingState {}

final class GroupSubmitError extends GroupBookingState {
  final String message;

  GroupSubmitError({required this.message});
}
