import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/meta_model.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/user_profile_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/home/models/home_model.dart';
import 'package:skygate/features/home/models/offer_model.dart';
import 'package:skygate/features/home/models/service_model.dart';
import 'package:skygate/features/home/models/travel_category_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  HomeCubit get(BuildContext context) => BlocProvider.of(context);

  // ── Travel categories ──────────────────────────────────────────────────
  final List<TravelCategoryModel> categories = TravelCategoryModel.catalogue;
  String selectedCategoryId = TravelCategoryModel.catalogue.first.id;

  void selectCategory(String id) {
    if (selectedCategoryId == id) return;
    selectedCategoryId = id;
    emit(CategorySelected());
  }

  // ── Services grid ──────────────────────────────────────────────────────
  final List<ServiceModel> services = ServiceModel.catalogue;

  // ── Home payload ───────────────────────────────────────────────────────
  UserProfileModel? user;
  List<HomeCityModel> cities = const [];
  List<HomeNotificationModel> notifications = const [];
  int get unreadNotifications =>
      notifications.where((alert) => !alert.isRead).length;
  List<OfferModel> offers = [];
  Meta tripsMeta = Meta.empty();
  HomeCityModel? selectedCity;

  void selectCity(HomeCityModel? city) {
    if (selectedCity?.id == city?.id) return;
    selectedCity = city;
    emit(CitySelected());
  }

  // ── Travel date ────────────────────────────────────────────────────────
  DateTime? travelDate;

  void selectTravelDate(DateTime date) {
    travelDate = date;
    emit(TravelDateSelected());
  }

  Future<void> getHome() async {
    emit(HomeLoading());
    try {
      final response = await DioService.get(ApiEndpoints.home);
      final body = response.data['data'];
      final home = HomeModel.fromJson(
        body is Map<String, dynamic> ? body : const {},
      );

      user = home.user;
      cities = home.cities;
      notifications = home.notifications;
      tripsMeta = home.trips.meta;
      offers = OfferModel.carouselOf(
        vipTrips: home.vipTrips,
        trips: home.trips.items,
      );
      emit(HomeLoaded());
    } catch (error) {
      debugPrint('getHome error: $error');
      emit(HomeError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> searchTrips() async {
    emit(HomeLoading());
    try {
      final response = await DioService.get(
        ApiEndpoints.tripsSearch,
        queryParameters: {
          if (travelDate != null)
            'start_date': travelDate!.toIso8601String().split('T').first,
          if (selectedCity?.id != null) 'city_id': selectedCity!.id,
        },
      );

      final body = response.data['data'];
      final trips = ApiParse.listOf(
        body is Map ? body['items'] : body,
        TripModel.fromJson,
      );

      tripsMeta = Meta.of(
        response.data['meta'] ?? (body is Map ? body['meta'] : null),
      );
      offers = OfferModel.carouselOf(vipTrips: const [], trips: trips);
      emit(HomeLoaded());
    } catch (error) {
      debugPrint('searchTrips error: $error');
      emit(HomeError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> readNotification(HomeNotificationModel alert) async {
    final id = alert.id;
    if (id == null || alert.isRead) return;

    alert.readAt = DateTime.now();
    emit(NotificationRead());

    try {
      await DioService.post(ApiEndpoints.readNotification(id));
    } catch (error) {
      debugPrint('readNotification error: $error');
    }
  }
}
