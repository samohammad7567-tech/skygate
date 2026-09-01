import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/features/group_booking/models/group_room_type.dart';
import 'package:skygate/features/group_booking/models/traveler_audience.dart';

/// The price sheet of one room size — the orange column on a room card.
///
/// Built from one entry of the trip's `packages[]`, so [packageId] is the
/// `package_id` every room of this size is booked against.
///
/// A room prices its first infant at [infantPrice] and every infant after it at
/// [secondInfantPrice], which is the "الرضيع الثاني" row in the design — the
/// endpoint's `price_infant_with_seat`.
class GroupRoomPriceModel {
  GroupRoomPriceModel({
    this.packageId,
    this.type = GroupRoomType.single,
    this.audience,
    this.adultPrice,
    this.childPrice,
    this.infantPrice,
    this.secondInfantPrice,
    this.bedLockFee,
    this.currency,
    this.almostFull = false,
  });

  /// The `package_id` sent inside `rooms[]`.
  final int? packageId;

  final GroupRoomType type;

  /// Who the package is sold to, e.g. "عائلات".
  final String? audience;

  final num? adultPrice;
  final num? childPrice;
  final num? infantPrice;
  final num? secondInfantPrice;

  /// "إغلاق السرير الواحد" — charged per bed left unbooked in the room.
  final num? bedLockFee;

  /// Currency as the API prints it, e.g. `SAR`.
  final String? currency;

  /// Turns on the red "شارفت على الانتهاء" chip. The endpoint publishes no
  /// remaining-seats count yet, so it stays off.
  final bool almostFull;

  /// The room size comes from resolving the package's `room_type`, which the
  /// back office may have entered as a slug or in Arabic.
  factory GroupRoomPriceModel.fromPackage(TripPackageModel package) =>
      GroupRoomPriceModel(
        packageId: package.id,
        type: GroupRoomType.fromApi(package.roomType),
        audience: package.audience,
        adultPrice: package.priceAdult,
        childPrice: package.priceChild,
        infantPrice: package.priceInfant,
        secondInfantPrice: package.priceInfantWithSeat,
        bedLockFee: package.bedLockFee,
        currency: package.currency,
      );

  /// What one traveller costs in this room. [isSecondInfant] switches an infant
  /// onto the "الرضيع الثاني" rate.
  num priceOf(TravelerAudience audience, {bool isSecondInfant = false}) {
    switch (audience) {
      case TravelerAudience.adult:
        return adultPrice ?? 0;
      case TravelerAudience.child:
        return childPrice ?? 0;
      case TravelerAudience.infant:
        return (isSecondInfant ? secondInfantPrice : infantPrice) ?? 0;
    }
  }
}
