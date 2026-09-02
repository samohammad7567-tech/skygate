import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';

part 'trips_state.dart';

/// "رحلاتي" — every booking of the signed-in pilgrim, split across the three
/// tabs by the standing the API gives it.
///
/// `GET app/bookings` takes no `status` parameter, so the whole list comes down
/// in one call and the tab only decides which rows are printed. Nothing is
/// paginated here for the same reason.
class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(TripsInitial());

  TripsCubit get(BuildContext context) => BlocProvider.of(context);

  /// Every booking, in the order the API lists them.
  List<BookingTripModel> _all = [];

  /// What the list prints — [_all] narrowed to [tab].
  List<BookingTripModel> bookings = [];

  TripsTab tab = TripsTab.current;

  void changeTab(TripsTab value) {
    if (tab == value) return;
    tab = value;
    _applyTab();
    emit(BookingsLoaded());
  }

  Future<void> getBookings() async {
    emit(BookingsLoading());
    try {
      final response = await DioService.get(ApiEndpoints.bookings);
      final body = response.data['data'];
      _all = [
        if (body is List)
          for (final item in body)
            if (item is Map<String, dynamic>) BookingTripModel.fromJson(item),
      ];
      _applyTab();
      emit(BookingsLoaded());
    } catch (error) {
      debugPrint('getBookings error: $error');
      emit(BookingsError(message: ApiError.messageOf(error)));
    }
  }

  void _applyTab() => bookings = [
    for (final booking in _all)
      if (tab.accepts(booking)) booking,
  ];
}
