import 'package:skygate/core/models/group_room_type.dart';

class GroupRoomAllocation {
  GroupRoomAllocation();

  final Map<GroupRoomType, int> counts = {};

  int of(GroupRoomType type) => counts[type] ?? 0;

  int get total => counts.values.fold(0, (sum, count) => sum + count);

  bool get isEmpty => total == 0;
  void replaceWith(Map<GroupRoomType, int> next) {
    counts
      ..clear()
      ..addEntries(next.entries.where((entry) => entry.value > 0));
  }
}
