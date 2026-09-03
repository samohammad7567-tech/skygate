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

/// The tourism module is starting up after its button was tapped.
final class SplashTourismBooting extends SplashState {}

/// The tourism module is up; [route] is the page it should open on.
final class SplashTourismReady extends SplashState {
  SplashTourismReady({required this.route});

  final String route;
}

/// The tourism module failed to start; the screen shows [errorKey] and the
/// slideshow resumes so the user can try either line again.
final class SplashTourismFailed extends SplashState {
  SplashTourismFailed({required this.errorKey});

  final String errorKey;
}
