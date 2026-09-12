import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_stepper_button.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
  final int max;

  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.s),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.s, vertical: 4.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20.s),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppStepperButton(
                  icon: Icons.remove,
                  onTap: count > 0 ? () => onChanged(count - 1) : null,
                ),
                SizedBox(
                  width: 36.s,
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                AppStepperButton(
                  icon: Icons.add,
                  onTap: count < max ? () => onChanged(count + 1) : null,
                ),
              ],
            ),
          ),
          Gap(12.s),
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
