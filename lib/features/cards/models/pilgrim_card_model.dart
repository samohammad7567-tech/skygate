import 'package:skygate/core/utils/api_parse.dart';

/// What `app/pilgrims/{id}/id-card` publishes: the face of a pilgrim's card,
/// and the PDF of it.
///
/// The endpoint has no documented schema, so every field is read through the
/// spellings the rest of the trip resources use, and a card that comes back
/// half-filled still renders — the rows print an em dash.
class PilgrimCardModel {
  String? tripNumber;
  DateTime? departureDate;
  DateTime? returnDate;

  String? passportNumber;
  String? qrUrl;
  String? emergencyPhone;
  String? fileUrl;

  List<PilgrimCardStayModel> stays = const [];

  PilgrimCardModel.fromJson(Map<String, dynamic> json) {
    final trip = json['trip'];
    final tripJson = trip is Map<String, dynamic> ? trip : const {};

    tripNumber = ApiParse.stringOf(
      json['trip_number'] ?? tripJson['trip_number'] ?? json['campaign_number'],
    );
    departureDate = ApiParse.dateOf(
      json['departure_date'] ??
          json['start_date_g'] ??
          tripJson['start_date_g'],
    );
    returnDate = ApiParse.dateOf(
      json['return_date'] ?? json['end_date_g'] ?? tripJson['end_date_g'],
    );
    passportNumber = ApiParse.stringOf(json['passport_number']);
    qrUrl = ApiParse.stringOf(json['qr_url'] ?? json['qr_code_url']);
    emergencyPhone = ApiParse.stringOf(
      json['emergency_phone'] ?? json['emergency_number'],
    );
    fileUrl = ApiParse.stringOf(
      json['file_url'] ?? json['pdf_url'] ?? json['card_url'],
    );
    stays = ApiParse.listOf(
      json['hotels'] ?? json['stays'] ?? tripJson['hotels'],
      PilgrimCardStayModel.fromJson,
    );
  }

  /// The card face prints Makkah above Madinah; anything else the trip
  /// carries follows in the order the API sent it.
  PilgrimCardStayModel? get makkah => _cityLike(['makk', 'مكة', 'مكه']);
  PilgrimCardStayModel? get madinah =>
      _cityLike(['madin', 'medin', 'المدينة', 'المدينه']);

  PilgrimCardStayModel? _cityLike(List<String> words) {
    for (final stay in stays) {
      final haystack = '${stay.city ?? ''} ${stay.name ?? ''}'.toLowerCase();
      if (words.any(haystack.contains)) return stay;
    }
    return null;
  }
}

class PilgrimCardStayModel {
  String? city;
  String? name;
  String? nameEn;
  String? phone;
  DateTime? checkIn;
  DateTime? checkOut;

  PilgrimCardStayModel.fromJson(Map<String, dynamic> json) {
    city = ApiParse.stringOf(json['city']);
    name = ApiParse.stringOf(json['name'] ?? json['hotel_name']);
    nameEn = ApiParse.stringOf(json['name_en'] ?? json['hotel_name_en']);
    phone = ApiParse.stringOf(json['contact_phone'] ?? json['phone']);
    checkIn = ApiParse.dateOf(json['check_in_date'] ?? json['check_in']);
    checkOut = ApiParse.dateOf(json['check_out_date'] ?? json['check_out']);
  }
}
