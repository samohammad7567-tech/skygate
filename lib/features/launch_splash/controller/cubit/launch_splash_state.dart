part of 'launch_splash_cubit.dart';

@immutable
sealed class LaunchSplashState {}

final class LaunchSplashInitial extends LaunchSplashState {}

/// The clip is decoded and playing; the screen can show the frames.
final class LaunchSplashReady extends LaunchSplashState {}

/// The clip ended, failed or was skipped — move on to the choice screen.
final class LaunchSplashFinished extends LaunchSplashState {}
