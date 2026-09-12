import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/features/journey_details/widgets/activity_rating_tags.dart';

/// "تقييم النشاط" — the stars, the optional tags, and a free note.
///
/// The sheet owns the draft; only a submitted rating reaches the cubit, which
/// is why the stars and the note live in local state rather than on it.
class ActivityRatingSheet extends StatefulWidget {
  const ActivityRatingSheet({
    super.key,
    required this.activity,
    required this.onSubmit,
  });

  final ActivityModel activity;

  /// Called with the score and whatever the pilgrim wrote — the tags they
  /// ticked are folded into the comment, which is all the API takes.
  final void Function(int rating, String? comment) onSubmit;

  static Future<void> show(
    BuildContext context, {
    required ActivityModel activity,
    required void Function(int rating, String? comment) onSubmit,
  }) => showAppSheet<void>(
    context,
    builder: (_) => ActivityRatingSheet(activity: activity, onSubmit: onSubmit),
  );

  @override
  State<ActivityRatingSheet> createState() => _ActivityRatingSheetState();
}

class _ActivityRatingSheetState extends State<ActivityRatingSheet> {
  final TextEditingController _note = TextEditingController();
  final Set<String> _tags = {};
  int _rating = 0;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// The API takes one comment, so the ticked tags are sent in front of the
  /// free note rather than being dropped.
  String? get _comment {
    final parts = [
      for (final key in ActivityRatingTags.all)
        if (_tags.contains(key)) key.tr(),
      if (_note.text.trim().isNotEmpty) _note.text.trim(),
    ];
    return parts.isEmpty ? null : parts.join(' • ');
  }

  void _submit() {
    Navigator.of(context).pop();
    widget.onSubmit(_rating, _comment);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetHandle(),
              const Gap(14),
              Center(
                child: Text(
                  'rate_activity_title'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Gap(16),
              _Stars(
                rating: _rating,
                onChanged: (value) => setState(() => _rating = value),
              ),
              const Gap(14),
              ActivityRatingTags(
                selected: _tags,
                note: _note,
                onToggle: (key) => setState(
                  () =>
                      _tags.contains(key) ? _tags.remove(key) : _tags.add(key),
                ),
              ),
              const Gap(14),
              const _ThanksCard(),
              const Gap(18),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'send_rating'.tr(),
                      height: 48,
                      // Stars are the one required part; everything under
                      // them is marked optional on the design itself.
                      onPressed: _rating > 0 ? _submit : null,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AppOutlinedButton(
                      label: 'cancel'.tr(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The five stars and the word under them.
class _Stars extends StatelessWidget {
  const _Stars({required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  static const List<String> _words = [
    'rating_poor',
    'rating_fair',
    'rating_good',
    'rating_very_good',
    'rating_excellent',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          Text(
            'rate_activity_question'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const Gap(4),
          Text(
            'rate_activity_hint'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var star = 1; star <= 5; star++)
                IconButton(
                  onPressed: () => onChanged(star),
                  iconSize: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    star <= rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.accent,
                  ),
                ),
            ],
          ),
          const Gap(8),
          Text(
            rating == 0 ? '' : _words[rating - 1].tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThanksCard extends StatelessWidget {
  const _ThanksCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.thumb_up_outlined,
              size: 22,
              color: theme.colorScheme.primary,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'thanks_for_rating'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Gap(2),
                Text(
                  'thanks_for_rating_desc'.tr(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
