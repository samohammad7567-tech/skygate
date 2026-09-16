import 'package:skygate/features/group_booking/models/group_room_price_model.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';

class GroupRoomModel {
  GroupRoomModel({required this.type, required this.price});

  final GroupRoomType type;
  final GroupRoomPriceModel? price;
  final List<int> travelerIds = [];
  int lockedBeds = 0;

  int get capacity => type.capacity;
  int get freeBeds => capacity - travelerIds.length;

  bool get isEmpty => travelerIds.isEmpty;
  bool get isSettled => travelerIds.isNotEmpty && freeBeds == lockedBeds;

  String? get currency => price?.currency;
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

  num get lockedBedsFee => lockedBeds * (price?.bedLockFee ?? 0);
  num total(List<TravelerAudience> audiences) =>
      travelerPrices(audiences).fold<num>(0, (sum, item) => sum + item) +
      lockedBedsFee;
}
