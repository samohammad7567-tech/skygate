import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/home/models/offer_model.dart';
import 'package:skygate/features/home/models/service_model.dart';
import 'package:skygate/features/home/models/travel_category_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  HomeCubit get(BuildContext context) => BlocProvider.of(context);

  // ── Travel categories ──────────────────────────────────────────────────
  /// Fixed design content, so it is available before any request completes.
  final List<TravelCategoryModel> categories = TravelCategoryModel.catalogue;

  /// Id of the highlighted pill — `عمرة` is selected in the design.
  String selectedCategoryId = TravelCategoryModel.catalogue.first.id;

  void selectCategory(String id) {
    if (selectedCategoryId == id) return;
    selectedCategoryId = id;
    emit(CategorySelected());
  }

  // ── Services grid ──────────────────────────────────────────────────────
  final List<ServiceModel> services = ServiceModel.catalogue;

  // ── Travel date ────────────────────────────────────────────────────────
  DateTime? travelDate;

  void selectTravelDate(DateTime date) {
    travelDate = date;
    emit(TravelDateSelected());
  }

  // ── Offers ─────────────────────────────────────────────────────────────
  /// The cards the carousel prints — [OfferModel.catalogue] narrowed to the
  /// selected category.
  List<OfferModel> offers = [];

  /// Fills the carousel from the stand-in catalogue.
  ///
  /// Nothing is fetched: `GET offers` is not in the OpenAPI document, and the
  /// nearest published endpoint lists only the trips a pilgrim is already
  /// booked on — without a price, a cover or an inclusions row, none of which
  /// the card can do without. It stays a `Future` so the pull-to-refresh and
  /// the search button keep their call sites when the endpoint lands.
  Future<void> getOffers() async {
    emit(OffersLoading());
    offers = [
      for (final offer in OfferModel.catalogue)
        if (offer.category == selectedCategoryId) offer,
    ];
    emit(OffersLoaded());
  }

  // ── Custom trip request ────────────────────────────────────────────────
  Future<void> requestCustomTrip() async {
    emit(CustomTripLoading());
    return DioService.post(
      ApiEndpoints.customTripRequest,
      data: {
        'category': selectedCategoryId,
        if (travelDate != null) 'travel_date': travelDate!.toIso8601String(),
      },
    ).then((_) => emit(CustomTripSubmitted())).catchError((error) {
      debugPrint('requestCustomTrip error: $error');
      emit(CustomTripError(message: ApiError.messageOf(error)));
    });
  }
}
