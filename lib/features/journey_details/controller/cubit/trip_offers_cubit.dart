import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/journey_details/models/trip_offer_model.dart';

part 'trip_offers_state.dart';

/// Owns "عروض الرحلة" — the price sets and which booking type the traveller
/// picked on each of them.
///
/// An offer is one entry of the trip's `packages[]`: the room type it prices
/// and the `package_id` a booking is created against.
class TripOffersCubit extends Cubit<TripOffersState> {
  TripOffersCubit(this.tripId) : super(TripOffersInitial());

  TripOffersCubit get(BuildContext context) => BlocProvider.of(context);

  final int tripId;

  List<TripOfferModel> offers = [];

  /// Booking type highlighted on each offer, keyed by the offer's index.
  final Map<int, BookingType> selectedBookingTypes = {};

  BookingType? selectedBookingTypeAt(int index) =>
      selectedBookingTypes[index] ??
      (index < offers.length && offers[index].bookingTypes.isNotEmpty
          ? offers[index].bookingTypes.first
          : null);

  void selectBookingType(int index, BookingType type) {
    if (selectedBookingTypes[index] == type) return;
    selectedBookingTypes[index] = type;
    emit(BookingTypeSelected());
  }

  Future<void> getOffers({bool refresh = false}) async {
    emit(TripOffersLoading());
    try {
      final trip = await TripService.trip(tripId, refresh: refresh);
      offers = [
        for (final package in trip.packages)
          TripOfferModel.fromPackage(package),
      ];
      selectedBookingTypes.clear();
      emit(TripOffersLoaded());
    } catch (error) {
      debugPrint('getOffers error: $error');
      emit(TripOffersError(message: ApiError.messageOf(error)));
    }
  }
}
