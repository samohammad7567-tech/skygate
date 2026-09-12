import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_room_allocation.dart';
import 'package:skygate/core/models/group_room_type.dart';

class GroupRoomChips extends StatelessWidget {
  const GroupRoomChips({super.key, required this.allocation});

  final GroupRoomAllocation allocation;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.s,
      runSpacing: 8.s,
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
      padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 6.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.s),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20.s,
            width: 20.s,
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
          Gap(8.s),
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
