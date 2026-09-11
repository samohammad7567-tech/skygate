import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/models/trip_model.dart';

class OfferModel {
  OfferModel({
    this.id,
    this.title,
    this.code,
    this.image,
    this.departureDate,
    this.returnDate,
    this.departureDateHijri,
    this.returnDateHijri,
    this.durationDays,
    this.priceFrom,
    this.currency,
    this.bookingDeadline,
    this.isVip = false,
    this.inclusions = const [],
  });
  final int? id;

  final String? title;
  final String? code;
  final String? image;

  final DateTime? departureDate;
  final DateTime? returnDate;
  final String? departureDateHijri;
  final String? returnDateHijri;

  final int? durationDays;
  final num? priceFrom;
  final String? currency;
  final DateTime? bookingDeadline;
  final bool isVip;
  final List<String> inclusions;
  bool get isBookingOpen =>
      bookingDeadline == null || bookingDeadline!.isAfter(DateTime.now());
  factory OfferModel.fromTrip(TripModel trip, {bool isVip = false}) =>
      OfferModel(
        id: trip.id,
        title: trip.campaignName ?? trip.tripNumber,
        code: trip.tripNumber,
        departureDate: trip.startDate,
        returnDate: trip.endDate,
        departureDateHijri: trip.startDateHijri,
        returnDateHijri: trip.endDateHijri,
        durationDays: trip.durationDays,
        priceFrom: trip.priceRange?.from ?? trip.lowestAdultPrice,
        currency:
            trip.priceRange?.currency ?? trip.packages.firstOrNull?.currency,
        bookingDeadline: trip.bookingDeadline,
        isVip: isVip,
      );
  static List<OfferModel> carouselOf({
    required List<TripModel> vipTrips,
    required List<TripModel> trips,
  }) {
    final vipIds = {for (final trip in vipTrips) ?trip.id};

    return [
      for (final trip in vipTrips) OfferModel.fromTrip(trip, isVip: true),
      for (final trip in trips)
        if (!vipIds.contains(trip.id)) OfferModel.fromTrip(trip),
    ];
  }
}

class OfferInclusion {
  OfferInclusion._();

  static const Map<String, String> _assets = {
    'flight': HomeAssets.flight,
    'hotel': HomeAssets.hotel,
    'train': HomeAssets.train,
    'boat': HomeAssets.seaTransport,
    'car': HomeAssets.car,
    'accommodation': HomeAssets.mosque,
  };
  static const List<String> defaultOrder = [
    'flight',
    'hotel',
    'train',
    'boat',
    'car',
    'accommodation',
  ];

  static String? assetFor(String slug) => _assets[slug];
}
