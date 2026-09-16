import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/trips/widgets/trip_chips.dart';

class TripSummary extends StatelessWidget {
  const TripSummary({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trip.title ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (trip.tripNumber != null) ...[
                    Gap(2.s),
                    Text(
                      trip.tripNumber!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Gap(6.s),
            const TripInclusionsRow(),
          ],
        ),
        Gap(10.s),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TripDateChip(labelKey: 'departure', date: trip.startDate),
            ),
            Gap(6.s),
            Expanded(child: TripDurationDivider(days: trip.durationDays)),
            Gap(6.s),
            Expanded(
              child: TripDateChip(labelKey: 'return_date', date: trip.endDate),
            ),
          ],
        ),
      ],
    );
  }
}
