import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';

/// "أخبرنا المزيد (اختياري)" — the ready-made praises a pilgrim can tick, and
/// the box for anything they would rather write themselves.
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

  /// The six the design offers, in its order.
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
          const Gap(4),
          Text(
            'tell_us_more_hint'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const Gap(12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in all)
                _Tag(
                  labelKey: key,
                  isSelected: selected.contains(key),
                  onTap: () => onToggle(key),
                ),
            ],
          ),
          const Gap(14),
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
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintText: 'rating_note_hint'.tr(),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const Gap(8),
          Icon(Icons.edit_outlined, size: 18, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}
