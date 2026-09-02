import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/group_room_type.dart';

/// Top of the traveller picker: "من ترغب بإضافته إلى الغرفة الثنائية ؟" over
/// the rule, with "اختيار الكل" on the end side.
class GroupPickerHeader extends StatelessWidget {
  const GroupPickerHeader({
    super.key,
    required this.type,
    required this.onSelectAll,
  });

  /// The room being filled, named in the question.
  final GroupRoomType type;

  /// Seats as many travellers as the room takes, in list order.
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
        const Gap(12),
        const Divider(height: 1),
        const Gap(8),
        Row(
          children: [
            const Spacer(),
            OutlinedButton(
              onPressed: onSelectAll,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
