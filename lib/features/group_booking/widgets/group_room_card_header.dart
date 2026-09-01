import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/booking/widgets/room_beds_row.dart';
import 'package:skygate/features/group_booking/models/group_room_model.dart';

/// Tinted strip of a room card: the size and its beds on the start side, the
/// delete and edit chips on the end.
class GroupRoomCardHeader extends StatelessWidget {
  const GroupRoomCardHeader({
    super.key,
    required this.room,
    required this.onDelete,
    required this.onEdit,
  });

  final GroupRoomModel room;
  final VoidCallback onDelete;

  /// `null` until the room holds someone — an empty room has nothing to edit.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
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
                const Gap(4),
                RoomBedsRow(count: room.capacity),
              ],
            ),
          ),
          if (onEdit != null) ...[
            _ActionChip(icon: Icons.edit_outlined, onTap: onEdit!),
            const Gap(8),
          ],
          _ActionChip(icon: Icons.delete_outline, onTap: onDelete),
        ],
      ),
    );
  }
}

/// Round outlined chip carrying one of the card's actions.
class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.primary),
      ),
    );
  }
}
