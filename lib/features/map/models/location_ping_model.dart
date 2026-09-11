import 'package:skygate/core/utils/api_parse.dart';

class LocationPingModel {
  int? id;
  int? pilgrimId;
  int? tripId;
  double? latitude;
  double? longitude;
  DateTime? recordedAt;

  LocationPingModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    pilgrimId = ApiParse.intOf(json['pilgrim_id']);
    tripId = ApiParse.intOf(json['trip_id']);
    latitude = ApiParse.numOf(json['latitude'])?.toDouble();
    longitude = ApiParse.numOf(json['longitude'])?.toDouble();
    recordedAt = ApiParse.dateOf(json['recorded_at']) ?? DateTime.now();
  }
  static Map<String, dynamic> body({
    required double latitude,
    required double longitude,
  }) => {'latitude': latitude, 'longitude': longitude};
}
