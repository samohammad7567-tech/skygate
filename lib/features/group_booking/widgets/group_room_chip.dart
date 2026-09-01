import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/group_booking/models/group_room_allocation.dart';
import 'package:skygate/features/group_booking/models/group_room_type.dart';

/// "غرفة ثنائية ①" pills under a hotel card — one per size the hotel took.
class GroupRoomChips extends StatelessWidget {
  const GroupRoomChips({super.key, required this.allocation});

  final GroupRoomAllocation allocation;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final type in GroupRoomType.values)
          if (allocation.of(type) > 0)
            _RoomChip(type: type, count: allocation.of(type)),
      ],
    );
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({required this.type, required this.count});

  final GroupRoomType type;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary),
            ),
            child: Text(
              '$count',
              maxLines: 1,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const Gap(8),
          Text(
            type.labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
