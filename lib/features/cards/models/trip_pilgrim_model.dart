import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/utils/api_parse.dart';

/// One traveller on the booking — the row every documents tab is grouped by.
///
/// The tabs read their documents from trip-wide endpoints that name a pilgrim
/// only through `booking_pilgrim_id`, so [id] is that booking-scoped id and
/// [pilgrimId] is the person's own id, which is what the card endpoints take.
class TripPilgrimModel {
  int? id;
  int? pilgrimId;

  String? fullName;
  String? fullNameEn;
  String? photo;
  String? passportNumber;

  TravelerAudience audience = TravelerAudience.adult;

  TripPilgrimModel.fromJson(Map<String, dynamic> json) {
    // A booking row either carries the person inline or nests them under
    // `pilgrim`; both spellings appear across the booking endpoints.
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

  /// `audience` is the field the booking flow posts; where a row carries only
  /// a birth date, the class is derived from it the way booking does.
  static TravelerAudience _audienceOf(Map<String, dynamic> json, Map pilgrim) {
    final label = json['audience'] ?? json['traveler_type'] ?? json['type'];
    if (label != null) return TravelerAudience.fromApi(label);

    final birth = ApiParse.dateOf(
      json['date_of_birth'] ?? json['dob'] ?? pilgrim['date_of_birth'],
    );
    return TravelerAudience.fromBirthDate(birth);
  }

  /// Pulls the roster out of a booking however that booking spells it: a flat
  /// `booking_pilgrims`/`pilgrims` list, or one nested per room.
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
