part of 'hotels_browse_cubit.dart';

@immutable
sealed class HotelsBrowseState {}

final class HotelsBrowseInitial extends HotelsBrowseState {}

final class HotelsBrowseLoading extends HotelsBrowseState {}

final class HotelsBrowseLoaded extends HotelsBrowseState {}

final class HotelsBrowseError extends HotelsBrowseState {
  HotelsBrowseError({required this.message});
  final String message;
}
