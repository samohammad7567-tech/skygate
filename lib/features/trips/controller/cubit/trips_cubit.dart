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

/// One page of one tab, held so stepping back to a tab already read is instant
/// and does not blank the list while a request is in flight.
class _TabPage {
  _TabPage(this.trips, this.meta);

  List<TripModel> trips;
  Meta meta;
}

class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(TripsInitial());

  TripsCubit get(BuildContext context) => BlocProvider.of(context);

  TripsTab tab = TripsTab.current;

  /// What the visible tab last came back with. The screen reads only this.
  List<TripModel> trips = const [];

  /// True while a page past the first is on its way, so the list can show a
  /// spinner at its foot rather than replacing the rows already on screen.
  bool isLoadingMore = false;

  final Map<TripsTab, _TabPage> _byTab = {};

  /// Whether the visible tab has another page behind the one on screen.
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

  /// Reads the visible tab. `filter[status]` is required by the endpoint, so
  /// every tab is its own request — nothing is filtered client-side.
  ///
  /// [page] past the first appends instead of replacing, which is what keeps
  /// the list from jumping back to the top as the user scrolls.
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
      // `my-trips` answers with trips, not bookings: the same shape the rest
      // of the app already reads through `TripModel`, plus a nested `booking`
      // block. `rowsOf` unwraps the `{items: [...]}` envelope around them.
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

      // A failed page past the first must not wipe the rows already read —
      // the screen keeps them and only the foot of the list stops spinning.
      if (isFirstPage) {
        emit(TripsError(message: ApiError.messageOf(error)));
      } else {
        emit(TripsLoaded());
      }
    }
  }

  /// Called by the screen as the list nears its end.
  Future<void> loadMore() async {
    final next = _byTab[tab]?.meta.nextPage;
    if (next == null || isLoadingMore) return;
    await getTrips(page: next);
  }

  /// A reply for a tab the user has already left is dropped: emitting it would
  /// paint one tab's trips under another tab's heading.
  bool _isStale(TripsTab requested) => isClosed || tab != requested;
}
