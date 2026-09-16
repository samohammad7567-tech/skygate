import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/dio_service.dart';

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

  static void clear() => _cache.clear();
}
