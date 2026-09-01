import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';

part 'hotels_state.dart';

/// Owns the "الفنادق" list — its search text and sort order — plus the single
/// hotel behind "تفاصيل الحجز".
///
/// `GET app/trips/{id}` carries every hotel of the trip in one response and
/// takes no `search`, `sort` or `page` parameter, so the list is filtered and
/// ordered here and there is nothing to paginate.
class HotelsCubit extends Cubit<HotelsState> {
  HotelsCubit(this.tripId) : super(HotelsInitial());

  HotelsCubit get(BuildContext context) => BlocProvider.of(context);

  final int tripId;

  // ── List ───────────────────────────────────────────────────────────────
  /// Every hotel of the trip, in the order it lists them.
  List<HotelModel> _all = [];

  /// What the list prints — [_all] narrowed by [query] and put in [sort].
  List<HotelModel> hotels = [];

  /// Text typed into the search field. The field itself is uncontrolled, so
  /// the cubit only keeps the value it last searched for.
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
  /// The hotel behind "تفاصيل الحجز".
  ///
  /// The API has no hotel endpoint: every field the screen prints already
  /// travelled down with the trip, so the card it was tapped from is the whole
  /// record.
  HotelModel? hotel;

  void showHotel(HotelModel selected) {
    hotel = selected;
    emit(HotelLoaded());
  }
}
