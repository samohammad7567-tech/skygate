part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class CategorySelected extends HomeState {}

final class TravelDateSelected extends HomeState {}

final class OffersLoading extends HomeState {}

final class OffersLoaded extends HomeState {}

final class OffersError extends HomeState {
  final String message;

  OffersError({required this.message});
}

final class CustomTripLoading extends HomeState {}

final class CustomTripSubmitted extends HomeState {}

final class CustomTripError extends HomeState {
  final String message;

  CustomTripError({required this.message});
}
