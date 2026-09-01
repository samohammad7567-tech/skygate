import 'package:skygate/features/group_booking/models/group_traveler_model.dart';

/// One traveller seated in a room, and what that seat costs there.
///
/// The cubit builds these so the room cards, the picker and the summary all
/// print the same figures without working any of them out themselves.
///
/// [isSecondInfant] is what turns the pink badge on: the second infant in a
/// room is charged the "الرضيع الثاني" rate rather than the first-infant one.
typedef GroupRoomSeat = ({
  GroupTravelerModel traveler,
  num price,
  bool isSecondInfant,
});
