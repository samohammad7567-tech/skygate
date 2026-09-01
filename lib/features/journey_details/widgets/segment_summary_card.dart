import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/journey_duration_row.dart';
import 'package:skygate/features/journey_details/widgets/journey_leg_row.dart';

/// Top block of "تفاصيل القسم": the carrier strip, the leg, and its length.
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
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              JourneyLegRow(from: segment.from, to: segment.to, showCode: true),
              const SizedBox(height: 10),
              JourneyDurationRow(minutes: segment.durationMinutes),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tinted header: the operator on the start side, the trip number chip on the
/// end side.
class _CarrierStrip extends StatelessWidget {
  const _CarrierStrip({this.companyName, this.tripNumber});

  final String? companyName;
  final String? tripNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
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
            const SizedBox(width: 8),
            Text(
              '${'trip_number'.tr()} :',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
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
