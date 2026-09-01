import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/features/journey_details/models/activity_model.dart';

/// One card on the activities timeline: title, the two location fields, and
/// the hours the activity runs for.
class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            activity.title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _Field(
            asset: JourneyAssets.location,
            labelKey: 'activity_place',
            value: activity.place,
          ),
          const SizedBox(height: 8),
          _Field(
            asset: JourneyAssets.meetingPoint,
            labelKey: 'meeting_point',
            value: activity.meetingPoint,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: IconTextRow(
                  asset: JourneyAssets.clockFrom,
                  text: 'from_hour'.tr(args: [activity.fromTime ?? '—']),
                ),
              ),
              const SizedBox(width: 12),
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
        ],
      ),
    );
  }
}

/// Label on the start side and a read-only tinted box holding the value.
class _Field extends StatelessWidget {
  const _Field({required this.asset, required this.labelKey, this.value});

  final String asset;
  final String labelKey;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        AppImage(
          asset,
          height: 18,
          width: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 6),
                AppImage(
                  JourneyAssets.pinpoint,
                  height: 14,
                  width: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
