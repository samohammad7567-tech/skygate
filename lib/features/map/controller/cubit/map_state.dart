part of 'map_cubit.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

final class MapLoaded extends MapState {}

final class MapPermissionRequesting extends MapState {}

final class MapPermissionDenied extends MapState {
  MapPermissionDenied({required this.access});

  final LocationAccess access;
}

final class MapReconnecting extends MapState {}

final class MapReconnectFailed extends MapState {
  MapReconnectFailed({required this.message});

  final String message;
}

final class MapPositionChanged extends MapState {}

final class MapDateSelected extends MapState {}

final class MapActivityFocused extends MapState {}

final class MapError extends MapState {
  MapError({required this.message});

  final String message;
}
