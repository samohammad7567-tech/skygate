import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/dio_service.dart';

/// Reads `GET app/trips/{id}` — the single call behind every journey-details
/// screen and both booking wizards.
///
/// The endpoint answers with the whole trip: its packages, hotels, itinerary
/// and staff. Six screens each want a different slice of it, and the booking
/// wizard walks three steps that each need one, so the result is kept for the
/// session instead of being fetched again per screen. Pull-to-refresh and the
/// retry button pass `refresh: true` to go back to the network.
class TripService {
  TripService._();

  static final Map<int, TripModel> _cache = {};

  static Future<TripModel> trip(int id, {bool refresh = false}) async {
    final cached = _cache[id];
    if (cached != null && !refresh) return cached;

    final response = await DioService.get(ApiEndpoints.trip(id));
    final body = response.data['data'];
    final trip = TripModel.fromJson(
      body is Map<String, dynamic> ? body : const {},
    );

    return _cache[id] = trip;
  }

  /// Drops the cache. Called on logout, when the next account must not see the
  /// previous one's trip.
  static void clear() => _cache.clear();
}
