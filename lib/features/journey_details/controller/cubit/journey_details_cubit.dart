import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';

part 'journey_details_state.dart';

/// Owns "رحلة مكة" and its "مسارات الرحلة" tabs, plus the leg behind the
/// "تفاصيل القسم" screen.
///
/// All three read the same call — `GET app/trips/{id}` — which carries the
/// campaign, its staff, its hotels and its itinerary in one response.
class JourneyDetailsCubit extends Cubit<JourneyDetailsState> {
  JourneyDetailsCubit(this.tripId) : super(JourneyDetailsInitial());

  JourneyDetailsCubit get(BuildContext context) => BlocProvider.of(context);

  final int tripId;

  TripModel? trip;

  Future<TripModel> _loadTrip({bool refresh = false}) async {
    final loaded = await TripService.trip(tripId, refresh: refresh);
    trip = loaded;
    return loaded;
  }

  // ── Trip overview ──────────────────────────────────────────────────────
  JourneyPackageModel? package;

  /// The four "تفاصيل الرحلة" rows are fixed design content.
  final List<JourneySectionModel> sections = JourneySectionModel.catalogue;

  Future<void> getPackage() async {
    emit(PackageLoading());
    try {
      package = JourneyPackageModel.fromTrip(await _loadTrip(refresh: true));
      emit(PackageLoaded());
    } catch (error) {
      debugPrint('getPackage error: $error');
      emit(PackageError(message: ApiError.messageOf(error)));
    }
  }

  // ── Routes / itinerary ─────────────────────────────────────────────────
  List<JourneyRouteModel> routes = [];

  /// Index of the highlighted "المسار" tab; the first one in the design.
  int selectedRouteIndex = 0;

  JourneyRouteModel? get selectedRoute =>
      selectedRouteIndex < routes.length ? routes[selectedRouteIndex] : null;

  void selectRoute(int index) {
    if (selectedRouteIndex == index) return;
    selectedRouteIndex = index;
    emit(RouteSelected());
  }

  /// The trip's itinerary as the one route it publishes.
  ///
  /// The endpoint hands back a single flat `itinerary[]` rather than
  /// alternative routes, so the tab row shows one tab today and starts
  /// showing more the moment the backend groups the legs.
  Future<void> getRoutes() async {
    emit(RoutesLoading());
    try {
      final loaded = await _loadTrip();
      routes = loaded.itinerary.isEmpty
          ? []
          : [JourneyRouteModel.fromTrip(loaded)];
      if (selectedRouteIndex >= routes.length) selectedRouteIndex = 0;
      emit(RoutesLoaded());
    } catch (error) {
      debugPrint('getRoutes error: $error');
      emit(RoutesError(message: ApiError.messageOf(error)));
    }
  }

  // ── One leg ────────────────────────────────────────────────────────────
  /// The leg opened from the itinerary.
  ///
  /// The API has no endpoint for a single segment: everything it knows about
  /// a leg already travelled down with the trip, so the screen renders the
  /// card it was handed.
  JourneySegmentModel? segment;

  void showSegment(JourneySegmentModel selected) {
    segment = selected;
    emit(SegmentLoaded());
  }
}
