import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/app_scale.dart';

class GroupPickerHeader extends StatelessWidget {
  const GroupPickerHeader({
    super.key,
    required this.type,
    required this.onSelectAll,
  });
  final GroupRoomType type;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'who_to_add_to_room'.tr(args: [type.labelKey.tr()]),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        Gap(12.s),
        Divider(height: 1.s),
        Gap(8.s),
        Row(
          children: [
            const Spacer(),
            OutlinedButton(
              onPressed: onSelectAll,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.s),
                ),
              ),
              child: Text(
                'select_all'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
