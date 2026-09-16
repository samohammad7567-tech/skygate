import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/utils/api_parse.dart';

class TripPilgrimModel {
  int? id;
  int? pilgrimId;

  String? fullName;
  String? fullNameEn;
  String? photo;
  String? passportNumber;

  TravelerAudience audience = TravelerAudience.adult;

  TripPilgrimModel.fromJson(Map<String, dynamic> json) {
    final nested = json['pilgrim'];
    final pilgrim = nested is Map<String, dynamic> ? nested : const {};

    id = ApiParse.intOf(json['id'] ?? json['booking_pilgrim_id']);
    pilgrimId = ApiParse.intOf(
      json['pilgrim_id'] ?? pilgrim['id'] ?? json['id'],
    );
    fullName = ApiParse.stringOf(
      json['full_name'] ?? json['name'] ?? pilgrim['full_name'],
    );
    fullNameEn = ApiParse.stringOf(
      json['full_name_en'] ?? pilgrim['full_name_en'],
    );
    photo = ApiParse.stringOf(json['photo_url'] ?? pilgrim['photo_url']);
    passportNumber = ApiParse.stringOf(
      json['passport_number'] ?? pilgrim['passport_number'],
    );
    audience = _audienceOf(json, pilgrim);
  }

  String get displayName => fullName ?? fullNameEn ?? '—';
  static TravelerAudience _audienceOf(Map<String, dynamic> json, Map pilgrim) {
    final label = json['audience'] ?? json['traveler_type'] ?? json['type'];
    if (label != null) return TravelerAudience.fromApi(label);

    final birth = ApiParse.dateOf(
      json['date_of_birth'] ?? json['dob'] ?? pilgrim['date_of_birth'],
    );
    return TravelerAudience.fromBirthDate(birth);
  }

  static List<TripPilgrimModel> rosterOf(dynamic booking) {
    if (booking is! Map) return const [];

    final flat = booking['booking_pilgrims'] ?? booking['pilgrims'];
    if (flat is List) return ApiParse.listOf(flat, TripPilgrimModel.fromJson);

    final rooms = booking['rooms'];
    if (rooms is! List) return const [];

    return [
      for (final room in rooms)
        if (room is Map)
          ...ApiParse.listOf(
            room['booking_pilgrims'] ?? room['pilgrims'],
            TripPilgrimModel.fromJson,
          ),
    ];
  }
}
