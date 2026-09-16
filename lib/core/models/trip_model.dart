import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/utils/api_parse.dart';

class TripModel {
  int? id;
  String? tripNumber;
  String? campaignName;
  DateTime? bookingDeadline;
  DateTime? startDate;
  DateTime? endDate;
  String? startDateHijri;
  String? endDateHijri;

  String? accessType;
  String? status;
  String? programPdfUrl;
  String? imageUrl;
  bool isVip = false;
  String? filterStatus;
  int? apiDurationDays;
  List<JourneyTransport> transportModes = const [];
  int? currentLeg;
  TripBookingSummaryModel? booking;
  int? pilgrimsCount;
  TripPriceRangeModel? priceRange;
  num? mapCenterLat;
  num? mapCenterLng;
  List<TripPackageModel> packages = const [];
  List<TripItineraryPackagesModel> packagesByItinerary = const [];

  List<TripHotelModel> hotels = const [];
  List<TripCitySummaryModel> citiesSummary = const [];
  List<TripItineraryModel> itinerary = const [];
  List<TripActivityModel> activities = const [];
  List<TripStaffModel> staff = const [];
  List<TripPaymentScheduleModel> paymentSchedules = const [];

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
    imageUrl = ApiEndpoints.mediaUrl(
      ApiParse.stringOf(json['trip_image_url'] ?? json['image']),
    );
    isVip = ApiParse.boolOf(json['is_vip'], orElse: false);
    filterStatus = ApiParse.labelOf(json['filter_status']);
    apiDurationDays = ApiParse.intOf(json['duration_days']);
    transportModes = [
      for (final mode in ApiParse.stringsOf(json['transport_modes']))
        JourneyTransport.fromApi(mode),
    ];
    currentLeg = ApiParse.intOf(
      json['current_leg'] ?? json['current_segment_index'],
    );
    booking = TripBookingSummaryModel.of(json['booking']);
    pilgrimsCount = ApiParse.intOf(
      json['pilgrims_count'] ?? json['travelers_count'] ?? json['seats_taken'],
    );
    priceRange = TripPriceRangeModel.of(json['price_range']);
    mapCenterLat = ApiParse.numOf(json['map_center_lat']);
    mapCenterLng = ApiParse.numOf(json['map_center_lng']);
    packages = ApiParse.listOf(json['packages'], TripPackageModel.fromJson);
    packagesByItinerary = ApiParse.listOf(
      json['packages_by_itinerary'],
      TripItineraryPackagesModel.fromJson,
    );
    hotels = ApiParse.listOf(json['hotels'], TripHotelModel.fromJson);
    citiesSummary = ApiParse.listOf(
      json['cities_summary'],
      TripCitySummaryModel.fromJson,
    );
    itinerary = ApiParse.listOf(json['itinerary'], TripItineraryModel.fromJson)
      ..sort((a, b) => (a.sequenceOrder ?? 0).compareTo(b.sequenceOrder ?? 0));
    activities = ApiParse.listOf(
      json['activities'],
      TripActivityModel.fromJson,
    );
    staff = ApiParse.listOf(json['staff'], TripStaffModel.fromJson);
    paymentSchedules = ApiParse.listOf(
      json['payment_schedules'],
      TripPaymentScheduleModel.fromJson,
    );
  }
  String? get title => campaignName ?? tripNumber;
  int? get durationDays =>
      apiDurationDays ?? ApiParse.daysBetween(startDate, endDate);
  bool get isBookingOpen =>
      bookingDeadline == null || bookingDeadline!.isAfter(DateTime.now());
  num? get lowestAdultPrice {
    final prices = [for (final package in packages) ?package.priceAdult];
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }
}

class TripPriceRangeModel {
  TripPriceRangeModel({this.min, this.max, this.currency});

  final num? min;
  final num? max;
  final String? currency;

  static TripPriceRangeModel? of(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      final min = ApiParse.numOf(value['min'] ?? value['from']);
      final max = ApiParse.numOf(value['max'] ?? value['to']);
      if (min == null && max == null) return null;
      return TripPriceRangeModel(
        min: min,
        max: max,
        currency: ApiParse.stringOf(value['currency']),
      );
    }

    final single = ApiParse.numOf(value);
    return single == null
        ? null
        : TripPriceRangeModel(min: single, max: single);
  }

  num? get from => min ?? max;
}

class TripBookingSummaryModel {
  int? id;
  String? reference;
  String? status;

  num? total;
  num? paid;
  num? remainingAmount;
  num? paymentPercentage;
  String? currency;

  TripBookingSummaryModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    reference = ApiParse.stringOf(json['booking_reference']);
    status = ApiParse.labelOf(json['status']);
    total = ApiParse.numOf(json['total_amount']);
    paid = ApiParse.numOf(json['paid_amount']);
    remainingAmount = ApiParse.numOf(json['remaining_amount']);
    paymentPercentage = ApiParse.numOf(json['payment_percentage']);
    currency = ApiParse.stringOf(json['currency']);
  }

  static TripBookingSummaryModel? of(dynamic value) =>
      value is Map<String, dynamic>
      ? TripBookingSummaryModel.fromJson(value)
      : null;

  num get outstanding {
    final stated = remainingAmount;
    if (stated != null) return stated < 0 ? 0 : stated;
    final left = (total ?? 0) - (paid ?? 0);
    return left < 0 ? 0 : left;
  }

  bool get isFullyPaid => outstanding <= 0;
}

class TripPackageModel {
  int? id;
  String? roomType;
  String? audience;
  TripAudienceLabelsModel? audienceLabels;
  int? itineraryId;

  num? priceAdult;
  num? priceChild;
  num? priceInfant;
  num? priceInfantWithSeat;
  num? bedLockFee;

  String? currency;
  int? availableRooms;

  TripPackageModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    roomType = ApiParse.stringOf(json['room_type']);
    audience = ApiParse.stringOf(json['audience']);
    audienceLabels = TripAudienceLabelsModel.of(json['audience_labels']);
    itineraryId = ApiParse.intOf(json['itinerary_id']);
    priceAdult = ApiParse.numOf(json['price_adult']);
    priceChild = ApiParse.numOf(json['price_child']);
    priceInfant = ApiParse.numOf(json['price_infant']);
    priceInfantWithSeat = ApiParse.numOf(json['price_infant_with_seat']);
    bedLockFee = ApiParse.numOf(json['bed_lock_fee']);
    currency = ApiParse.stringOf(json['currency']);
    availableRooms = ApiParse.intOf(json['available_rooms']);
  }
  bool get hasRooms => availableRooms == null || availableRooms! > 0;
}

class TripAudienceLabelsModel {
  TripAudienceLabelsModel({
    required this.individual,
    required this.group,
    this.individualLabel,
    this.groupLabel,
  });

  final bool individual;
  final bool group;
  final String? individualLabel;
  final String? groupLabel;

  static TripAudienceLabelsModel? of(dynamic value) {
    if (value is! Map) return null;
    return TripAudienceLabelsModel(
      individual: value['individual'] == true,
      group: value['group'] == true,
      individualLabel: ApiParse.stringOf(value['individual_label']),
      groupLabel: ApiParse.stringOf(value['group_label']),
    );
  }
}

class TripItineraryPackagesModel {
  int? itineraryId;
  String? itineraryName;
  String? segmentType;

  List<TripPackageModel> packages = const [];

  TripItineraryPackagesModel.fromJson(Map<String, dynamic> json) {
    itineraryId = ApiParse.intOf(json['itinerary_id']);
    itineraryName = ApiParse.stringOf(json['itinerary_name']);
    segmentType = ApiParse.stringOf(json['segment_type']);
    packages = ApiParse.listOf(json['packages'], TripPackageModel.fromJson);
  }
}

class TripHotelModel {
  int? id;
  String? name;
  String? city;
  num? rating;
  num? latitude;
  num? longitude;
  List<String> addressDetails = const [];

  String? contactPhone;
  DateTime? checkInDate;
  DateTime? checkOutDate;
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
  String? get address =>
      addressDetails.isEmpty ? null : addressDetails.join('، ');
  int? get nights => ApiParse.nightsBetween(checkInDate, checkOutDate);
}

class TripCitySummaryModel {
  String? city;
  int? nights;
  List<String> hotels = const [];

  DateTime? checkIn;
  DateTime? checkOut;

  TripCitySummaryModel.fromJson(Map<String, dynamic> json) {
    city = ApiParse.stringOf(json['city']);
    nights = ApiParse.intOf(json['nights']);
    hotels = ApiParse.stringsOf(json['hotels']);
    checkIn = ApiParse.dateOf(json['check_in']);
    checkOut = ApiParse.dateOf(json['check_out']);
  }
}

class TripItineraryModel {
  int? id;
  int? sequenceOrder;
  String? segmentType;

  String? originCity;
  String? destinationCity;
  TripCarrierModel? carrier;
  String? flightNumber;
  String? vehicleRef;
  String? trainRef;
  TripVehicleModel? vehicle;

  DateTime? departureTime;
  DateTime? arrivalTime;

  TripItineraryModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    sequenceOrder = ApiParse.intOf(json['sequence_order']);
    segmentType = ApiParse.stringOf(json['segment_type']);
    originCity = ApiParse.stringOf(json['origin_city']);
    destinationCity = ApiParse.stringOf(json['destination_city']);
    carrier = TripCarrierModel.of(json['carrier']);
    flightNumber = ApiParse.stringOf(json['flight_number']);
    vehicleRef = ApiParse.stringOf(json['vehicle_ref']);
    trainRef = ApiParse.stringOf(json['train_ref']);
    vehicle = TripVehicleModel.of(json['vehicle']);
    departureTime = ApiParse.dateOf(json['departure_time']);
    arrivalTime = ApiParse.dateOf(json['arrival_time']);
  }
  String? get reference => flightNumber ?? trainRef ?? vehicleRef;
  String? get transportType => segmentType ?? carrier?.carrierType;
  int? get durationMinutes {
    final from = departureTime;
    final to = arrivalTime;
    if (from == null || to == null) return null;
    final minutes = to.difference(from).inMinutes;
    return minutes < 0 ? null : minutes;
  }
}

class TripCarrierModel {
  TripCarrierModel({this.id, this.name, this.logoUrl, this.carrierType});

  final int? id;
  final String? name;
  final String? logoUrl;
  final String? carrierType;

  static TripCarrierModel? of(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      return TripCarrierModel(
        id: ApiParse.intOf(value['id']),
        name: ApiParse.stringOf(value['name']),
        logoUrl: ApiParse.stringOf(value['logo_url']),
        carrierType: ApiParse.stringOf(value['carrier_type']),
      );
    }

    final name = ApiParse.stringOf(value);
    return name == null ? null : TripCarrierModel(name: name);
  }
}

class TripVehicleModel {
  TripVehicleModel({this.vehicleType, this.capacity});
  final String? vehicleType;
  final int? capacity;

  static TripVehicleModel? of(dynamic value) {
    if (value is! Map) return null;
    final vehicle = TripVehicleModel(
      vehicleType: ApiParse.stringOf(value['vehicle_type']),
      capacity: ApiParse.intOf(value['capacity']),
    );
    return vehicle.vehicleType == null && vehicle.capacity == null
        ? null
        : vehicle;
  }
}

class TripActivityModel {
  int? id;
  String? title;
  DateTime? activityDate;
  String? startTime;
  String? endTime;

  num? meetingPointLat;
  num? meetingPointLng;
  String? meetingPointText;
  String? status;
  String? attendanceStatus;
  num? feedbackRating;

  TripActivityTypeModel? activityType;

  TripActivityModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    title = ApiParse.stringOf(json['title']);
    activityDate = ApiParse.dateOf(json['activity_date']);
    startTime = ApiParse.timeOf(json['start_time']);
    endTime = ApiParse.timeOf(json['end_time']);
    meetingPointLat = ApiParse.numOf(json['meeting_point_lat']);
    meetingPointLng = ApiParse.numOf(json['meeting_point_lng']);
    meetingPointText = ApiParse.stringOf(json['meeting_point_text']);
    status = ApiParse.labelOf(json['status']);
    attendanceStatus = ApiParse.labelOf(
      json['attendance_status'] ?? json['attendance'],
    );
    feedbackRating = ApiParse.numOf(
      json['feedback_rating'] ?? json['rating'] ?? json['my_rating'],
    );
    activityType = TripActivityTypeModel.of(json['activity_type']);
  }
}

class TripActivityTypeModel {
  TripActivityTypeModel({this.id, this.name, this.color, this.icon});

  final int? id;
  final String? name;
  final String? color;
  final String? icon;

  static TripActivityTypeModel? of(dynamic value) {
    if (value is! Map) return null;
    return TripActivityTypeModel(
      id: ApiParse.intOf(value['id']),
      name: ApiParse.stringOf(value['name']),
      color: ApiParse.stringOf(value['color']),
      icon: ApiParse.stringOf(value['icon']),
    );
  }
}

class TripStaffModel {
  int? id;
  String? name;
  String? role;

  TripStaffModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
    role = ApiParse.labelOf(json['role']);
  }
}

class TripPaymentScheduleModel {
  int? id;
  String? type;
  String? installmentName;
  int? minAmountPercent;
  int? durationInHours;
  DateTime? dueDate;

  TripPaymentScheduleModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    type = ApiParse.labelOf(json['type']);
    installmentName = ApiParse.stringOf(json['installment_name']);
    minAmountPercent = ApiParse.intOf(json['min_amount_percent']);
    durationInHours = ApiParse.intOf(json['duration_in_hours']);
    dueDate = ApiParse.dateOf(json['due_date']);
  }
  bool get isDuration => type == 'duration' || dueDate == null;
}
