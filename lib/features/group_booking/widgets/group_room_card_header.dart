import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/room_beds_row.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_room_model.dart';

class GroupRoomCardHeader extends StatelessWidget {
  const GroupRoomCardHeader({
    super.key,
    required this.room,
    required this.onDelete,
    required this.onEdit,
  });

  final GroupRoomModel room;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(14.s, 10.s, 14.s, 10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.s)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.type.labelKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Gap(4.s),
                RoomBedsRow(count: room.capacity),
              ],
            ),
          ),
          if (onEdit != null) ...[
            _ActionChip(icon: Icons.edit_outlined, onTap: onEdit!),
            Gap(8.s),
          ],
          _ActionChip(icon: Icons.delete_outline, onTap: onDelete),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkResponse(
      onTap: onTap,
      radius: 24.s,
      child: Container(
        height: 34.s,
        width: 34.s,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Icon(icon, size: 18.s, color: theme.colorScheme.primary),
      ),
    );
  }
}
