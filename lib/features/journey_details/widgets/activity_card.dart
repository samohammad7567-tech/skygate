import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/widgets/activity_action_button.dart';
import 'package:skygate/features/journey_details/widgets/activity_place_field.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
    this.onAction,
    this.isBusy = false,
  });

  final ActivityModel activity;

  /// Opens "تفاصيل النشاط". The search list leaves it null.
  final VoidCallback? onTap;

  /// Check-in or rating, whichever the card is offering. Null on the lists
  /// that only show activities rather than act on them.
  final VoidCallback? onAction;

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.fromLTRB(12.s, 10.s, 12.s, 10.s),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  activity.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 8.s),
              _Chip(activity: activity),
            ],
          ),
          SizedBox(height: 8.s),
          Divider(height: 1.s),
          SizedBox(height: 8.s),
          ActivityPlaceField(
            asset: JourneyAssets.location,
            labelKey: 'activity_place',
            value: activity.place,
          ),
          SizedBox(height: 8.s),
          ActivityPlaceField(
            asset: JourneyAssets.meetingPoint,
            labelKey: 'meeting_point',
            value: activity.meetingPoint,
          ),
          SizedBox(height: 8.s),
          Divider(height: 1.s),
          SizedBox(height: 8.s),
          Row(
            children: [
              Flexible(
                child: IconTextRow(
                  asset: JourneyAssets.clockFrom,
                  text: 'from_hour'.tr(args: [activity.fromTime ?? '—']),
                ),
              ),
              SizedBox(width: 12.s),
              Flexible(
                child: IconTextRow(
                  asset: JourneyAssets.clockTo,
                  text: 'to_hour'.tr(args: [activity.toTime ?? '—']),
                  textStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          if (onAction != null) ...[
            SizedBox(height: 10.s),
            ActivityActionButton(
              action: activity.action,
              isBusy: isBusy,
              onPressed: onAction!,
            ),
          ],
        ],
      ),
    );
  }
}

/// Where the activity stands against the clock, or — while it is still only
/// scheduled — what kind of activity it is.
class _Chip extends StatelessWidget {
  const _Chip({required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = activity.progress;

    if (progress.labelKey case final labelKey?) {
      return AppStatusChip(
        labelKey: labelKey,
        background: progress.background,
        foreground: progress.foreground,
        radius: 6.s,
      );
    }

    // `activity_type` names the kind and picks its colour; a programme that
    // publishes neither keeps the plain title row.
    if (activity.typeName == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.s, vertical: 3.s),
      decoration: BoxDecoration(
        color: activity.surfaceColor,
        borderRadius: BorderRadius.circular(20.s),
      ),
      // The chip sits beside a two-line title, so it takes at most a third of
      // the row rather than pushing the title into an ellipsis.
      constraints: BoxConstraints(maxWidth: 110.s),
      child: Text(
        activity.typeName!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: activity.accentColor,
          fontSize: 11.fs,
        ),
      ),
    );
  }
}
