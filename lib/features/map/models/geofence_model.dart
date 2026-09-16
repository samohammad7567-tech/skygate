import 'dart:math' as math;

import 'package:skygate/core/utils/api_parse.dart';

/// One safe area drawn by the trip leader, as returned by
/// `GET app/trip-safe-area`.
///
/// The endpoint returns a list, not a single circle: a leader may draw one ring
/// around the Haram and another around the hotel. Draw every one of them.
class TripGeofenceModel {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  double? radiusMeters;
  bool isActive = true;

  TripGeofenceModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
    latitude = ApiParse.numOf(json['latitude'])?.toDouble();
    longitude = ApiParse.numOf(json['longitude'])?.toDouble();
    radiusMeters = ApiParse.numOf(
      json['radius_meters'] ?? json['radius'],
    )?.toDouble();
    isActive = ApiParse.boolOf(json['is_active'], orElse: true);
  }

  /// A disabled circle is a historical record, not a live boundary — drawing
  /// one would show the pilgrim a line that alerts nobody when crossed. The
  /// server already filters them out; this guards against the ones it doesn't.
  bool get isDrawable =>
      isActive &&
      latitude != null &&
      longitude != null &&
      (radiusMeters ?? 0) > 0;

  /// Metres from this circle's centre to a point, on a spherical earth.
  double? distanceTo(double latitude, double longitude) {
    final centreLat = this.latitude;
    final centreLng = this.longitude;
    if (centreLat == null || centreLng == null) return null;

    const double earthRadius = 6371000;
    final dLat = _radians(latitude - centreLat);
    final dLng = _radians(longitude - centreLng);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_radians(centreLat)) *
            math.cos(_radians(latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  bool contains(double latitude, double longitude) {
    if (!isDrawable) return false;
    final metres = distanceTo(latitude, longitude);
    return metres != null && metres <= radiusMeters!;
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
