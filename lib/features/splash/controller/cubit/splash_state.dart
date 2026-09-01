part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

/// The timer wants the carousel to move on; the screen animates its
/// [PageController] and the resulting page change comes back as
/// [SplashSlideChanged].
final class SplashSlideAdvanced extends SplashState {}

final class SplashSlideChanged extends SplashState {}

final class SplashServiceSelected extends SplashState {
  SplashServiceSelected({required this.service});

  final SplashService service;
}
