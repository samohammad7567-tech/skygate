part of 'trip_offers_cubit.dart';

@immutable
sealed class TripOffersState {}

final class TripOffersInitial extends TripOffersState {}

final class TripOffersLoading extends TripOffersState {}

final class TripOffersLoaded extends TripOffersState {}

final class BookingTypeSelected extends TripOffersState {}

final class TripOffersError extends TripOffersState {
  final String message;

  TripOffersError({required this.message});
}
