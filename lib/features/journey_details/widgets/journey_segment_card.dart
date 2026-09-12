import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/models/time_progress.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/journey_leg_row.dart';

/// One leg on "مسار الرحلة": which leg it is and how it is going, both ends
/// of it, then how long it runs beside the way into its details.
class JourneySegmentCard extends StatelessWidget {
  const JourneySegmentCard({
    super.key,
    required this.segment,
    required this.position,
    this.onTap,
  });

  final JourneySegmentModel segment;
  final int position;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = segment.progress;

    return AppCard(
      // A finished leg is greyed back so the live one reads first.
      color: progress == TimeProgress.finished
          ? theme.colorScheme.surfaceContainerHighest
          : null,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  segment.title ??
                      AppFormat.ordinalTitle('segment_title', position),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              if (progress.labelKey case final labelKey?) ...[
                const SizedBox(width: 8),
                AppStatusChip(
                  labelKey: labelKey,
                  background: progress.background,
                  foreground: progress.foreground,
                  radius: 6,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          JourneyLegRow(from: segment.from, to: segment.to),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // The design reads duration first, then the way in: gold on the
          // starting edge, the button on the far one.
          Row(
            children: [
              Flexible(child: _Duration(minutes: segment.durationMinutes)),
              const Spacer(),
              _DetailsButton(onTap: onTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        side: BorderSide(color: theme.colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        'view_details'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Duration extends StatelessWidget {
  const _Duration({required this.minutes});

  final int? minutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      '${'trip_duration'.tr()}: ${AppFormat.duration(minutes)}',
      textAlign: TextAlign.end,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
