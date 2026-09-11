part of 'carriers_cubit.dart';

@immutable
sealed class CarriersState {}

final class CarriersInitial extends CarriersState {}

final class CarriersLoading extends CarriersState {}

final class CarriersLoaded extends CarriersState {}

final class CarriersError extends CarriersState {
  CarriersError({required this.message});
  final String message;
}
