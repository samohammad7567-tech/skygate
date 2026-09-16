part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class CategorySelected extends HomeState {}

final class CitySelected extends HomeState {}

final class TravelDateSelected extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {}

final class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

final class NotificationRead extends HomeState {}
