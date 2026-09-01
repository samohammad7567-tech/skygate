import 'package:skygate/features/group_booking/models/group_room_type.dart';

/// How many rooms of each size one hotel takes — the chips printed under a
/// hotel card on "اختر فندق مكة المكرمة".
///
/// The rooms themselves were created on the previous step; this only records
/// where each city puts them, so the counts here can never add up to more than
/// the rooms the group booked.
class GroupRoomAllocation {
  GroupRoomAllocation();

  final Map<GroupRoomType, int> counts = {};

  int of(GroupRoomType type) => counts[type] ?? 0;

  int get total => counts.values.fold(0, (sum, count) => sum + count);

  bool get isEmpty => total == 0;

  /// Replaces the whole sheet, dropping the sizes set back to zero so an empty
  /// allocation really is [isEmpty].
  void replaceWith(Map<GroupRoomType, int> next) {
    counts
      ..clear()
      ..addEntries(next.entries.where((entry) => entry.value > 0));
  }
}
