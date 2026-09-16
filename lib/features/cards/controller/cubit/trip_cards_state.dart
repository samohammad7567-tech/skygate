part of 'trip_cards_cubit.dart';

@immutable
sealed class TripCardsState {}

final class TripCardsInitial extends TripCardsState {}

final class TripCardsLoading extends TripCardsState {}

final class TripCardsLoaded extends TripCardsState {}

final class TripCardsError extends TripCardsState {
  TripCardsError({required this.message});

  final String message;
}

final class DocumentOpened extends TripCardsState {}

final class DocumentFailed extends TripCardsState {
  DocumentFailed({required this.message});

  final String message;
}
