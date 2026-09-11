part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashSlideAdvanced extends SplashState {}

final class SplashSlideChanged extends SplashState {}

final class SplashServiceSelected extends SplashState {
  SplashServiceSelected({required this.service});

  final SplashService service;
}

final class SplashTourismBooting extends SplashState {}

final class SplashTourismReady extends SplashState {
  SplashTourismReady({required this.route});

  final String route;
}

final class SplashTourismFailed extends SplashState {
  SplashTourismFailed({required this.errorKey});

  final String errorKey;
}
