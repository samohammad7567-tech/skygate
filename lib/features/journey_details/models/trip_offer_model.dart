import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/trip_model.dart';

/// One bookable price set on "عروض الرحلة".
///
/// Built from one entry of the trip's `packages[]`, which is what
/// `POST app/bookings` calls a `package_id`: a room type at its four rates.
class TripOfferModel {
  TripOfferModel({
    this.id,
    this.routeTitle,
    this.routeName,
    this.bookingTypes = const [],
    this.roomType,
    this.adultPrice,
    this.childPrice,
    this.infantPrice,
    this.bedLockFee,
    this.currency,
  });

  /// The `package_id` the booking is created against.
  final int? id;

  /// Ordinal caption of the card. Null falls back to "العرض الأول".
  final String? routeTitle;

  /// Who the package is sold to, printed in orange after the title.
  final String? routeName;

  /// Booking types this offer can be taken as.
  final List<BookingType> bookingTypes;

  /// Room the price assumes, e.g. "ثنائية".
  final String? roomType;

  final num? adultPrice;
  final num? childPrice;
  final num? infantPrice;

  /// "إغلاق السرير الواحد" — what an unbooked bed in the room costs.
  final num? bedLockFee;

  /// Currency as the API prints it, e.g. `SAR`.
  final String? currency;

  /// One package as a card.
  ///
  /// The endpoint does not say which booking types a package accepts, and both
  /// wizards can book any of them, so every card offers the pair.
  factory TripOfferModel.fromPackage(TripPackageModel package) =>
      TripOfferModel(
        id: package.id,
        routeName: package.audience,
        bookingTypes: BookingType.values,
        roomType: package.roomType,
        adultPrice: package.priceAdult,
        childPrice: package.priceChild,
        infantPrice: package.priceInfant,
        bedLockFee: package.bedLockFee,
        currency: package.currency,
      );
}
