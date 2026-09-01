part of 'booking_cubit.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

/// The wizard moved between steps, or a selection on the current step changed.
final class BookingStepChanged extends BookingState {}

final class BookingTypeSelected extends BookingState {}

// ── Passport ──────────────────────────────────────────────────────────────
final class PassportFieldChanged extends BookingState {}

final class PassportScanLoading extends BookingState {}

/// The user dismissed the camera / gallery picker without choosing a file.
final class PassportScanCancelled extends BookingState {}

final class PassportScanned extends BookingState {}

final class PassportScanError extends BookingState {
  final String message;

  PassportScanError({required this.message});
}

// ── Documents ─────────────────────────────────────────────────────────────
final class DocumentPicked extends BookingState {}

/// The picked file is over `ImagePickerService.maxSizeInBytes`.
final class FileTooLarge extends BookingState {}

// ── Routes ────────────────────────────────────────────────────────────────
final class BookingRoutesLoading extends BookingState {}

final class BookingRoutesLoaded extends BookingState {}

final class BookingRoutesError extends BookingState {
  final String message;

  BookingRoutesError({required this.message});
}

// ── Room types ────────────────────────────────────────────────────────────
final class RoomTypesLoading extends BookingState {}

final class RoomTypesLoaded extends BookingState {}

final class RoomTypesError extends BookingState {
  final String message;

  RoomTypesError({required this.message});
}

// ── Hotels ────────────────────────────────────────────────────────────────
final class BookingHotelsLoading extends BookingState {}

final class BookingHotelsLoaded extends BookingState {}

final class BookingHotelsError extends BookingState {
  final String message;

  BookingHotelsError({required this.message});
}

// ── Summary ───────────────────────────────────────────────────────────────
final class BookingSummaryLoading extends BookingState {}

final class BookingSummaryLoaded extends BookingState {}

/// One tick of the "أكمل الدفع خلال" countdown.
final class BookingCountdownTicked extends BookingState {}

final class BookingSummaryError extends BookingState {
  final String message;

  BookingSummaryError({required this.message});
}

// ── Submit ────────────────────────────────────────────────────────────────
final class BookingSubmitLoading extends BookingState {}

final class BookingSubmitted extends BookingState {}

final class BookingSubmitError extends BookingState {
  final String message;

  BookingSubmitError({required this.message});
}
