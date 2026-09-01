part of 'hotels_cubit.dart';

@immutable
sealed class HotelsState {}

final class HotelsInitial extends HotelsState {}

final class HotelsLoading extends HotelsState {}

final class HotelsLoaded extends HotelsState {}

final class HotelsError extends HotelsState {
  final String message;

  HotelsError({required this.message});
}

/// The hotel behind "تفاصيل الحجز" was handed to the cubit. It needs no
/// loading or error twin: the record travelled down with the trip.
final class HotelLoaded extends HotelsState {}
