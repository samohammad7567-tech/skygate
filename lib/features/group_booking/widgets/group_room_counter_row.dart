import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/group_room_type.dart';

/// One line of "حدد عدد الغرف و أنواعها": the room size on the start side and
/// its − 0 + stepper on the end.
class GroupRoomCounterRow extends StatelessWidget {
  const GroupRoomCounterRow({
    super.key,
    required this.type,
    required this.count,
    required this.max,
    required this.onChanged,
  });

  final GroupRoomType type;
  final int count;

  /// Ceiling for this size. On the hotel step it is what the other hotels
  /// have left over; on the rooms step there is no practical limit.
  final int max;

  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepButton(
                  icon: Icons.remove,
                  onTap: count > 0 ? () => onChanged(count - 1) : null,
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  onTap: count < max ? () => onChanged(count + 1) : null,
                ),
              ],
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              type.labelKey.tr(),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Round − / + control; greyed out once the count hits either end.
class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = onTap == null
        ? theme.colorScheme.outlineVariant
        : theme.colorScheme.primary;

    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Container(
        height: 26,
        width: 26,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
