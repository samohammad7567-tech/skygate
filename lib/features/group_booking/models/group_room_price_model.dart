import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';

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
  final int? packageId;

  final GroupRoomType type;
  final String? audience;

  final num? adultPrice;
  final num? childPrice;
  final num? infantPrice;
  final num? secondInfantPrice;
  final num? bedLockFee;
  final String? currency;
  final bool almostFull;
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
