import 'package:skygate/features/group_booking/models/group_room_price_model.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';

/// One room created on "اختر عدد الغرف و أنواعها", with the travellers put in
/// it and the beds paid for but left empty.
class GroupRoomModel {
  GroupRoomModel({required this.type, required this.price});

  final GroupRoomType type;

  /// The price sheet for [type]. `null` while the rates are still loading.
  final GroupRoomPriceModel? price;

  /// `GroupTravelerModel.localId` of everyone in the room, in the order they
  /// were added — which is also the order the infant rates are applied in.
  final List<int> travelerIds = [];

  /// Beds paid for under "إغلاق الأسرة" so the room can be booked without
  /// filling it.
  int lockedBeds = 0;

  int get capacity => type.capacity;

  /// Beds with nobody in them yet.
  int get freeBeds => capacity - travelerIds.length;

  bool get isEmpty => travelerIds.isEmpty;

  /// `true` once the room is either full or its spare beds have been locked.
  bool get isSettled => travelerIds.isNotEmpty && freeBeds == lockedBeds;

  String? get currency => price?.currency;

  /// What each traveller costs, in the order of [travelerIds].
  ///
  /// [audiences] must be resolved by the caller from the same order, because
  /// the room itself only stores ids.
  List<num> travelerPrices(List<TravelerAudience> audiences) {
    final sheet = price;
    if (sheet == null) return List.filled(audiences.length, 0);

    var infantsSoFar = 0;
    return [
      for (final audience in audiences)
        sheet.priceOf(
          audience,
          isSecondInfant:
              audience == TravelerAudience.infant && infantsSoFar++ > 0,
        ),
    ];
  }

  /// Fee charged for the beds left empty.
  num get lockedBedsFee => lockedBeds * (price?.bedLockFee ?? 0);

  /// "المجموع النهائي" printed at the bottom of the room card.
  num total(List<TravelerAudience> audiences) =>
      travelerPrices(audiences).fold<num>(0, (sum, item) => sum + item) +
      lockedBedsFee;
}
