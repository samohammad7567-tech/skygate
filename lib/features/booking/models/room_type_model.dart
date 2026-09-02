import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/group_room_type.dart';

/// One card on "اختر نوع الغرفة".
///
/// Built from one entry of the trip's `packages[]`, so [id] is the
/// `package_id` the created booking seats its room with.
class RoomTypeModel {
  RoomTypeModel({
    this.id,
    this.name,
    this.beds,
    this.adultPrice,
    this.bedLockFee,
    this.currency,
    this.almostFull = false,
  });

  /// The `package_id` sent inside `rooms[]`.
  final int? id;

  /// Localised name as the API prints it, e.g. "غرفة رباعية".
  final String? name;

  /// Beds in the room; the card repeats its glyph this many times.
  final int? beds;

  /// Price per adult, printed in orange.
  final num? adultPrice;

  /// "إغلاق السرير الواحد" — what an unbooked bed costs.
  final num? bedLockFee;

  /// Currency as the API prints it, e.g. `SAR`.
  final String? currency;

  /// Turns on the red "شارفت على الانتهاء" chip. The endpoint publishes no
  /// remaining-seats count yet, so it stays off.
  final bool almostFull;

  /// The bed count comes from resolving the package's `room_type` — the
  /// endpoint names the room but never says how many people sleep in it.
  factory RoomTypeModel.fromPackage(TripPackageModel package) => RoomTypeModel(
    id: package.id,
    name: package.roomType,
    beds: GroupRoomType.fromApi(package.roomType).capacity,
    adultPrice: package.priceAdult,
    bedLockFee: package.bedLockFee,
    currency: package.currency,
  );
}
