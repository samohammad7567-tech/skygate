import 'package:skygate/core/utils/api_parse.dart';

class TripGeofenceModel {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  double? radiusMeters;

  TripGeofenceModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
    latitude = ApiParse.numOf(json['latitude'])?.toDouble();
    longitude = ApiParse.numOf(json['longitude'])?.toDouble();
    radiusMeters = ApiParse.numOf(
      json['radius_meters'] ?? json['radius'],
    )?.toDouble();
  }
  bool get isDrawable =>
      latitude != null && longitude != null && (radiusMeters ?? 0) > 0;
}

class GeofenceBreachModel {
  int? pilgrimId;
  String? pilgrimName;
  String? geofenceName;
  String? lastLocationText;

  double? latitude;
  double? longitude;
  DateTime? lastSeenAt;

  GeofenceBreachModel.fromJson(Map<String, dynamic> json) {
    final pilgrim = json['pilgrim'];
    final pilgrimJson = pilgrim is Map ? pilgrim : const {};

    pilgrimId = ApiParse.intOf(json['pilgrim_id'] ?? pilgrimJson['id']);
    pilgrimName = ApiParse.stringOf(
      json['pilgrim_name'] ?? pilgrimJson['full_name'] ?? json['full_name'],
    );
    geofenceName = ApiParse.stringOf(
      json['geofence_name'] ?? json['name'] ?? json['trip_geofence_name'],
    );
    lastLocationText = ApiParse.stringOf(
      json['last_location'] ??
          json['last_known_location'] ??
          json['address'] ??
          json['location_text'],
    );
    latitude = ApiParse.numOf(
      json['latitude'] ?? json['last_latitude'],
    )?.toDouble();
    longitude = ApiParse.numOf(
      json['longitude'] ?? json['last_longitude'],
    )?.toDouble();
    lastSeenAt = ApiParse.dateOf(
      json['last_seen_at'] ??
          json['last_ping_at'] ??
          json['recorded_at'] ??
          json['created_at'],
    );
  }
}
