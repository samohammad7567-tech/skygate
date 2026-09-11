import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';

part 'journey_details_state.dart';

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
  int selectedRouteIndex = 0;

  JourneyRouteModel? get selectedRoute =>
      selectedRouteIndex < routes.length ? routes[selectedRouteIndex] : null;

  void selectRoute(int index) {
    if (selectedRouteIndex == index) return;
    selectedRouteIndex = index;
    emit(RouteSelected());
  }

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
  JourneySegmentModel? segment;

  void showSegment(JourneySegmentModel selected) {
    segment = selected;
    emit(SegmentLoaded());
  }
}
