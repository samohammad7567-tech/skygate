part of 'booking_changes_cubit.dart';

@immutable
sealed class BookingChangesState {}

final class BookingChangesInitial extends BookingChangesState {}

final class BookingChangesLoading extends BookingChangesState {}

final class BookingChangesLoaded extends BookingChangesState {}

final class BookingChangesError extends BookingChangesState {
  final String message;

  BookingChangesError({required this.message});
}

final class BookingChangeLoading extends BookingChangesState {}

final class BookingChangeLoaded extends BookingChangesState {}

final class BookingChangeError extends BookingChangesState {
  final String message;

  BookingChangeError({required this.message});
}
