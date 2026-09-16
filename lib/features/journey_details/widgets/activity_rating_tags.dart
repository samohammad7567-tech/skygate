import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ActivityRatingTags extends StatelessWidget {
  const ActivityRatingTags({
    super.key,
    required this.selected,
    required this.note,
    required this.onToggle,
  });

  final Set<String> selected;
  final TextEditingController note;
  final ValueChanged<String> onToggle;
  static const List<String> all = [
    'rating_tag_organisation',
    'rating_tag_team',
    'rating_tag_transport',
    'rating_tag_information',
    'rating_tag_timing',
    'rating_tag_other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 16.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'tell_us_more'.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Gap(4.s),
          Text(
            'tell_us_more_hint'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          Gap(12.s),
          Wrap(
            spacing: 8.s,
            runSpacing: 8.s,
            children: [
              for (final key in all)
                _Tag(
                  labelKey: key,
                  isSelected: selected.contains(key),
                  onTap: () => onToggle(key),
                ),
            ],
          ),
          Gap(14.s),
          _NoteField(controller: note),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.labelKey,
    required this.isSelected,
    required this.onTap,
  });

  final String labelKey;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return Material(
      color: isSelected
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(10.s),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.s),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 10.s),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.s),
            border: Border.all(color: color),
          ),
          child: Text(
            labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 2,
              minLines: 1,
              textInputAction: TextInputAction.done,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.s),
                hintText: 'rating_note_hint'.tr(),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          Gap(8.s),
          Icon(
            Icons.edit_outlined,
            size: 18.s,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
