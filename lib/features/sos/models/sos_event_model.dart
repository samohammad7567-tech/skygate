import 'package:skygate/core/utils/api_parse.dart';

class SosEventModel {
  int? id;
  int? pilgrimId;
  int? tripId;
  double? latitude;
  double? longitude;
  String? status;
  String? acknowledgedBy;
  DateTime? acknowledgedAt;
  DateTime? resolvedAt;
  List<String> resolutionNotes = const [];

  DateTime? createdAt;

  SosEventModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    pilgrimId = ApiParse.intOf(json['pilgrim_id']);
    tripId = ApiParse.intOf(json['trip_id']);
    latitude = ApiParse.numOf(json['latitude'])?.toDouble();
    longitude = ApiParse.numOf(json['longitude'])?.toDouble();
    status = ApiParse.labelOf(json['status']);
    acknowledgedBy = ApiParse.stringOf(json['acknowledged_by']);
    acknowledgedAt = ApiParse.dateOf(json['acknowledged_at']);
    resolvedAt = ApiParse.dateOf(json['resolved_at']);
    resolutionNotes = ApiParse.linesOf(json['resolution_notes']);
    createdAt = ApiParse.dateOf(json['created_at']);
  }
  bool get isAcknowledged => acknowledgedAt != null || resolvedAt != null;
  static Map<String, dynamic> body({
    required double latitude,
    required double longitude,
  }) => {'latitude': latitude, 'longitude': longitude};
}
