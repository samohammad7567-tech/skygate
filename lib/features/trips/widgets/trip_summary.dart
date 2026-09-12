import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/features/trips/widgets/trip_chips.dart';

/// The right-hand half of a "رحلاتي" card: the campaign's name and number with
/// what the trip includes drawn beside them, then the two date chips with the
/// length ruled between.
class TripSummary extends StatelessWidget {
  const TripSummary({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name and glyphs share a line in the design: the trip reads from the
        // outer edge, the inclusions trail away from it.
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
                    const Gap(2),
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
            const Gap(6),
            const TripInclusionsRow(),
          ],
        ),
        const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Outward first, so it reads from the outer edge inward.
            Expanded(
              child: TripDateChip(labelKey: 'departure', date: trip.startDate),
            ),
            const Gap(6),
            Expanded(child: TripDurationDivider(days: trip.durationDays)),
            const Gap(6),
            Expanded(
              child: TripDateChip(labelKey: 'return_date', date: trip.endDate),
            ),
          ],
        ),
      ],
    );
  }
}
