import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/group_room_type.dart';

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
  final int? id;
  final String? name;
  final int? beds;
  final num? adultPrice;
  final num? bedLockFee;
  final String? currency;
  final bool almostFull;
  factory RoomTypeModel.fromPackage(TripPackageModel package) => RoomTypeModel(
    id: package.id,
    name: package.roomType,
    beds: GroupRoomType.fromApi(package.roomType).capacity,
    adultPrice: package.priceAdult,
    bedLockFee: package.bedLockFee,
    currency: package.currency,
  );
}
