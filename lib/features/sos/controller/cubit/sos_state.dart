part of 'sos_cubit.dart';

@immutable
sealed class SosState {}

final class SosInitial extends SosState {}

final class SosHoldStarted extends SosState {}

final class SosHoldProgress extends SosState {
  SosHoldProgress({required this.progress});

  final double progress;
}

final class SosHoldCancelled extends SosState {}

final class SosSending extends SosState {}

final class SosRaised extends SosState {}

final class SosFailed extends SosState {
  SosFailed({required this.message, this.access});

  final String message;
  final LocationAccess? access;
}
