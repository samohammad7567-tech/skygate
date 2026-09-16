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

final class HotelLoaded extends HotelsState {}
