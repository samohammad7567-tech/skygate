part of 'trips_cubit.dart';

@immutable
sealed class TripsState {}

final class TripsInitial extends TripsState {}

final class TripsLoading extends TripsState {}

/// A page past the first is on its way. Distinct from [TripsLoading] because
/// the rows already on screen stay put while it runs.
final class TripsLoadingMore extends TripsState {}

final class TripsLoaded extends TripsState {}

final class TripsError extends TripsState {
  TripsError({required this.message});

  final String message;
}
