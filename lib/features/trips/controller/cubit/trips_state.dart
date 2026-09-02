part of 'trips_cubit.dart';

@immutable
sealed class TripsState {}

final class TripsInitial extends TripsState {}

final class BookingsLoading extends TripsState {}

final class BookingsLoaded extends TripsState {}

final class BookingsError extends TripsState {
  BookingsError({required this.message});

  final String message;
}
