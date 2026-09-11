import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/features/hotels/models/hotel_catalogue.dart';
import 'package:skygate/features/hotels/models/hotel_filter.dart';

part 'hotels_browse_state.dart';

class HotelsBrowseCubit extends Cubit<HotelsBrowseState> {
  HotelsBrowseCubit() : super(HotelsBrowseInitial());

  HotelsBrowseCubit get(BuildContext context) => BlocProvider.of(context);
  List<HotelModel> _all = [];
  List<HotelModel> hotels = [];
  String query = '';

  HotelFilter filter = const HotelFilter();

  Future<void> getHotels() async {
    emit(HotelsBrowseLoading());
    _all = HotelCatalogue.all;
    _applyFilters();
    emit(HotelsBrowseLoaded());
  }

  void search(String value) {
    query = value.trim();
    _applyFilters();
    emit(HotelsBrowseLoaded());
  }

  void applyFilter(HotelFilter value) {
    filter = value;
    _applyFilters();
    emit(HotelsBrowseLoaded());
  }

  void _applyFilters() {
    hotels = [
      for (final hotel in _all)
        if (hotel.matches(query) && filter.matches(hotel)) hotel,
    ]..sort(HotelSort.rating.compare);
  }
}
