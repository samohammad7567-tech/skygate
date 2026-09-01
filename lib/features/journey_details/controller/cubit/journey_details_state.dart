part of 'journey_details_cubit.dart';

@immutable
sealed class JourneyDetailsState {}

final class JourneyDetailsInitial extends JourneyDetailsState {}

final class PackageLoading extends JourneyDetailsState {}

final class PackageLoaded extends JourneyDetailsState {}

final class PackageError extends JourneyDetailsState {
  final String message;

  PackageError({required this.message});
}

final class RoutesLoading extends JourneyDetailsState {}

final class RoutesLoaded extends JourneyDetailsState {}

final class RouteSelected extends JourneyDetailsState {}

final class RoutesError extends JourneyDetailsState {
  final String message;

  RoutesError({required this.message});
}

/// The leg opened from the itinerary was handed to the cubit. It needs no
/// loading or error twin: the leg travelled down with the trip.
final class SegmentLoaded extends JourneyDetailsState {}
