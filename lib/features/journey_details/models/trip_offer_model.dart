import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/trip_model.dart';

class TripOfferModel {
  TripOfferModel({
    this.id,
    this.routeTitle,
    this.routeName,
    this.bookingTypes = const [],
    this.typeLabels = const {},
    this.roomType,
    this.adultPrice,
    this.childPrice,
    this.infantPrice,
    this.infantWithSeatPrice,
    this.bedLockFee,
    this.currency,
    this.availableRooms,
  });
  final int? id;
  final String? routeTitle;
  final String? routeName;
  final List<BookingType> bookingTypes;
  final Map<BookingType, String> typeLabels;
  final String? roomType;

  final num? adultPrice;
  final num? childPrice;
  final num? infantPrice;
  final num? infantWithSeatPrice;
  final num? bedLockFee;
  final String? currency;
  final int? availableRooms;
  bool get hasRooms => availableRooms == null || availableRooms! > 0;
  factory TripOfferModel.fromPackage(
    TripPackageModel package, {
    String? routeTitle,
  }) {
    final labels = package.audienceLabels;

    return TripOfferModel(
      id: package.id,
      routeTitle: routeTitle,
      routeName: _audienceLabel(package),
      bookingTypes: _bookingTypesOf(package),
      typeLabels: {
        BookingType.individual: ?labels?.individualLabel,
        BookingType.group: ?labels?.groupLabel,
      },
      roomType: package.roomType,
      adultPrice: package.priceAdult,
      childPrice: package.priceChild,
      infantPrice: package.priceInfant,
      infantWithSeatPrice: package.priceInfantWithSeat,
      bedLockFee: package.bedLockFee,
      currency: package.currency,
      availableRooms: package.availableRooms,
    );
  }
  static List<TripOfferModel> allOf(TripModel trip) {
    if (trip.packagesByItinerary.isEmpty) {
      return [
        for (final package in trip.packages)
          TripOfferModel.fromPackage(package),
      ];
    }

    return [
      for (final route in trip.packagesByItinerary)
        for (final package in route.packages)
          TripOfferModel.fromPackage(package, routeTitle: route.itineraryName),
    ];
  }

  static List<BookingType> _bookingTypesOf(TripPackageModel package) {
    final labels = package.audienceLabels;
    if (labels != null && (labels.individual || labels.group)) {
      return [
        if (labels.individual) BookingType.individual,
        if (labels.group) BookingType.group,
      ];
    }

    return switch (package.audience) {
      'individual' => const [BookingType.individual],
      'group' => const [BookingType.group],
      _ => BookingType.values,
    };
  }

  static String? _audienceLabel(TripPackageModel package) {
    final labels = package.audienceLabels;
    if (labels == null) return package.audience;

    return switch ((labels.individual, labels.group)) {
      (true, false) => labels.individualLabel,
      (false, true) => labels.groupLabel,
      _ => labels.individualLabel ?? labels.groupLabel,
    };
  }
}
