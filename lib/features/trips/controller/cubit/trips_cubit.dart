import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/meta_model.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';

part 'trips_state.dart';

class _TabPage {
  _TabPage(this.trips, this.meta);

  List<TripModel> trips;
  Meta meta;
}

class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(TripsInitial());

  TripsCubit get(BuildContext context) => BlocProvider.of(context);

  TripsTab tab = TripsTab.current;
  List<TripModel> trips = const [];
  bool isLoadingMore = false;

  final Map<TripsTab, _TabPage> _byTab = {};
  bool get hasMorePages => _byTab[tab]?.meta.hasMorePages ?? false;

  void changeTab(TripsTab value) {
    if (tab == value) return;
    tab = value;

    final cached = _byTab[value];
    if (cached == null) {
      getTrips();
      return;
    }
    trips = cached.trips;
    emit(TripsLoaded());
  }

  Future<void> getTrips({bool refresh = false, int page = 1}) async {
    final requested = tab;
    if (refresh) _byTab.remove(requested);

    final isFirstPage = page <= 1;
    if (isFirstPage) {
      trips = _byTab[requested]?.trips ?? const [];
      emit(TripsLoading());
    } else {
      if (isLoadingMore) return;
      isLoadingMore = true;
      emit(TripsLoadingMore());
    }

    try {
      final response = await DioService.get(
        ApiEndpoints.myTrips,
        queryParameters: {'filter[status]': requested.filter, 'page': page},
      );
      final data = response.data['data'];
      final loaded = ApiParse.rowsOf(data, TripModel.fromJson);
      final meta = Meta.of(data is Map ? data['meta'] : null);

      final cached = _byTab[requested];
      _byTab[requested] = isFirstPage || cached == null
          ? _TabPage(loaded, meta)
          : _TabPage([...cached.trips, ...loaded], meta);

      isLoadingMore = false;
      if (_isStale(requested)) return;

      trips = _byTab[requested]!.trips;
      emit(TripsLoaded());
    } catch (error) {
      debugPrint('getTrips(${requested.filter}, page $page) error: $error');
      isLoadingMore = false;
      if (_isStale(requested)) return;
      if (isFirstPage) {
        emit(TripsError(message: ApiError.messageOf(error)));
      } else {
        emit(TripsLoaded());
      }
    }
  }

  Future<void> loadMore() async {
    final next = _byTab[tab]?.meta.nextPage;
    if (next == null || isLoadingMore) return;
    await getTrips(page: next);
  }

  bool _isStale(TripsTab requested) => isClosed || tab != requested;
}
