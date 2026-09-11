part of 'launch_splash_cubit.dart';

@immutable
sealed class LaunchSplashState {}

final class LaunchSplashInitial extends LaunchSplashState {}

final class LaunchSplashReady extends LaunchSplashState {}

final class LaunchSplashFinished extends LaunchSplashState {}
