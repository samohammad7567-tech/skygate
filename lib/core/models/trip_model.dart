import 'package:skygate/core/utils/api_parse.dart';

/// `GET app/trips/{id}` — the one endpoint every browse and booking screen
/// reads from.
///
/// The document splits it into `TripResource` (the list) and
/// `TripDetailResource` (the single trip), the second being a superset of the
/// first, so both parse into this class: the four collections simply stay
/// empty on a list row.
///
/// Nothing here is shaped for a screen. The view models each flow already had
/// — `JourneyPackageModel`, `BookingRouteModel`, `HotelModel`, … — build
/// themselves from it, so the widgets never learn the API's field names.
class TripModel {
  int? id;
  String? tripNumber;
  String? campaignName;
  DateTime? bookingDeadline;

  /// Gregorian start / end. The Hijri pair is carried alongside for the
  /// screens that print both calendars.
  DateTime? startDate;
  DateTime? endDate;
  String? startDateHijri;
  String? endDateHijri;

  String? accessType;
  String? status;
  String? programPdfUrl;

  /// Centre of the trip's map, when the backend pins one.
  num? mapCenterLat;
  num? mapCenterLng;

  /// The bookable price sets — one per room type, and the `package_id`
  /// `POST app/bookings` seats its rooms with.
  List<TripPackageModel> packages = const [];

  List<TripHotelModel> hotels = const [];

  /// The trip's legs, in `sequence_order`.
  List<TripItineraryModel> itinerary = const [];

  /// "بإشراف" — the supervisors printed on the package overview.
  List<TripStaffModel> staff = const [];

  TripModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    tripNumber = ApiParse.stringOf(json['trip_number']);
    campaignName = ApiParse.stringOf(json['campaign_name']);
    bookingDeadline = ApiParse.dateOf(json['booking_deadline']);
    startDate = ApiParse.dateOf(json['start_date_g']);
    endDate = ApiParse.dateOf(json['end_date_g']);
    startDateHijri = ApiParse.stringOf(json['start_date_h']);
    endDateHijri = ApiParse.stringOf(json['end_date_h']);
    accessType = ApiParse.stringOf(json['access_type']);
    status = ApiParse.labelOf(json['status']);
    programPdfUrl = ApiParse.stringOf(json['trip_program_pdf_url']);
    mapCenterLat = ApiParse.numOf(json['map_center_lat']);
    mapCenterLng = ApiParse.numOf(json['map_center_lng']);
    packages = _list(json['packages'], TripPackageModel.fromJson);
    hotels = _list(json['hotels'], TripHotelModel.fromJson);
    itinerary = _list(json['itinerary'], TripItineraryModel.fromJson)
      ..sort((a, b) => (a.sequenceOrder ?? 0).compareTo(b.sequenceOrder ?? 0));
    staff = _list(json['staff'], TripStaffModel.fromJson);
  }

  /// The name the screens print — the campaign, or the trip number when the
  /// campaign has none.
  String? get title => campaignName ?? tripNumber;

  /// Length of the trip in days, printed over the hero photo.
  int? get durationDays => ApiParse.daysBetween(startDate, endDate);

  static List<T> _list<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) => [
    if (value is List)
      for (final item in value)
        if (item is Map<String, dynamic>) fromJson(item),
  ];
}

/// `TripPackageResource` — one room type at its four rates.
///
/// [id] is what `POST app/bookings` calls `package_id`, so every room the
/// wizards create has to remember which package priced it.
class TripPackageModel {
  int? id;

  /// Room the rates assume, e.g. `twin` or "ثنائية".
  String? roomType;

  /// Who the package is sold to, e.g. "عائلات". Printed as the offer's subtitle.
  String? audience;

  num? priceAdult;
  num? priceChild;
  num? priceInfant;

  /// The "الرضيع الثاني" rate — an infant given a seat of their own.
  num? priceInfantWithSeat;

  /// "إغلاق السرير الواحد" — charged per bed left unbooked in a room.
  num? bedLockFee;

  String? currency;

  TripPackageModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    roomType = ApiParse.stringOf(json['room_type']);
    audience = ApiParse.stringOf(json['audience']);
    priceAdult = ApiParse.numOf(json['price_adult']);
    priceChild = ApiParse.numOf(json['price_child']);
    priceInfant = ApiParse.numOf(json['price_infant']);
    priceInfantWithSeat = ApiParse.numOf(json['price_infant_with_seat']);
    bedLockFee = ApiParse.numOf(json['bed_lock_fee']);
    currency = ApiParse.stringOf(json['currency']);
  }
}

/// `TripHotelResource` — one hotel of the trip, with the dates the group stays
/// in it.
class TripHotelModel {
  int? id;
  String? name;
  String? city;
  num? rating;
  num? latitude;
  num? longitude;

  /// Street, district, landmark — printed as one line under the name.
  List<String> addressDetails = const [];

  String? contactPhone;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  /// The hotel the trip books by default in its city.
  bool isDefault = false;

  TripHotelModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
    city = ApiParse.stringOf(json['city']);
    rating = ApiParse.numOf(json['rating']);
    latitude = ApiParse.numOf(json['latitude']);
    longitude = ApiParse.numOf(json['longitude']);
    addressDetails = ApiParse.stringsOf(json['address_details']);
    contactPhone = ApiParse.stringOf(json['contact_phone']);
    checkInDate = ApiParse.dateOf(json['check_in_date']);
    checkOutDate = ApiParse.dateOf(json['check_out_date']);
    isDefault = json['is_default'] == true;
  }

  /// The address as one line.
  String? get address =>
      addressDetails.isEmpty ? null : addressDetails.join('، ');

  /// Nights the trip stays here.
  int? get nights => ApiParse.nightsBetween(checkInDate, checkOutDate);
}

/// `TripItineraryResource` — one leg of the trip.
class TripItineraryModel {
  int? id;
  int? sequenceOrder;

  /// `flight`, `bus`, `train`, `cruise`, … — resolved to a glyph by
  /// `JourneyTransport.fromApi`.
  String? segmentType;

  String? originCity;
  String? destinationCity;

  /// Airline, bus company or operator.
  String? carrier;

  DateTime? departureTime;
  DateTime? arrivalTime;

  TripItineraryModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    sequenceOrder = ApiParse.intOf(json['sequence_order']);
    segmentType = ApiParse.stringOf(json['segment_type']);
    originCity = ApiParse.stringOf(json['origin_city']);
    destinationCity = ApiParse.stringOf(json['destination_city']);
    carrier = ApiParse.stringOf(json['carrier']);
    departureTime = ApiParse.dateOf(json['departure_time']);
    arrivalTime = ApiParse.dateOf(json['arrival_time']);
  }

  /// Length of the leg in minutes, or `null` when either end has no date.
  int? get durationMinutes {
    final from = departureTime;
    final to = arrivalTime;
    if (from == null || to == null) return null;
    final minutes = to.difference(from).inMinutes;
    return minutes < 0 ? null : minutes;
  }
}

/// `TripStaffResource` — one name under "بإشراف".
class TripStaffModel {
  int? id;
  String? name;

  TripStaffModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
  }
}
