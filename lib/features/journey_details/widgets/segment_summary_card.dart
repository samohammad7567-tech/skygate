import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/journey_duration_row.dart';
import 'package:skygate/features/journey_details/widgets/journey_leg_row.dart';

class SegmentSummaryCard extends StatelessWidget {
  const SegmentSummaryCard({super.key, required this.segment});

  final JourneySegmentModel segment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CarrierStrip(
          companyName: segment.companyName,
          tripNumber: segment.tripNumber,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 10.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              JourneyLegRow(from: segment.from, to: segment.to, showCode: true),
              SizedBox(height: 10.s),
              JourneyDurationRow(minutes: segment.durationMinutes),
            ],
          ),
        ),
      ],
    );
  }
}

class _CarrierStrip extends StatelessWidget {
  const _CarrierStrip({this.companyName, this.tripNumber});

  final String? companyName;
  final String? tripNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.s)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              companyName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          if (tripNumber != null && tripNumber!.isNotEmpty) ...[
            SizedBox(width: 8.s),
            Text(
              '${'trip_number'.tr()} :',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(width: 6.s),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 4.s),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20.s),
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Text(
                tripNumber!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
