import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';

part 'hotels_state.dart';

class HotelsCubit extends Cubit<HotelsState> {
  HotelsCubit(this.tripId) : super(HotelsInitial());

  HotelsCubit get(BuildContext context) => BlocProvider.of(context);

  final int tripId;

  // ── List ───────────────────────────────────────────────────────────────
  List<HotelModel> _all = [];
  List<HotelModel> hotels = [];
  String query = '';

  HotelSort sort = HotelSort.rating;

  void search(String value) {
    query = value.trim();
    _applyFilters();
    emit(HotelsLoaded());
  }

  void changeSort(HotelSort value) {
    if (sort == value) return;
    sort = value;
    _applyFilters();
    emit(HotelsLoaded());
  }

  Future<void> getHotels({bool refresh = false}) async {
    emit(HotelsLoading());
    try {
      final trip = await TripService.trip(tripId, refresh: refresh);
      _all = [for (final hotel in trip.hotels) HotelModel.fromTripHotel(hotel)];
      _applyFilters();
      emit(HotelsLoaded());
    } catch (error) {
      debugPrint('getHotels error: $error');
      emit(HotelsError(message: ApiError.messageOf(error)));
    }
  }

  void _applyFilters() {
    hotels = [
      for (final hotel in _all)
        if (hotel.matches(query)) hotel,
    ]..sort(sort.compare);
  }

  // ── One hotel ──────────────────────────────────────────────────────────
  HotelModel? hotel;

  void showHotel(HotelModel selected) {
    hotel = selected;
    emit(HotelLoaded());
  }
}
