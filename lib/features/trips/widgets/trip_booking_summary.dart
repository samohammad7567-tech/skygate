import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';
import 'package:skygate/features/trips/widgets/trip_chips.dart';

/// The block beside a card's photo: the inclusions row, the trip name over its
/// number, then the departure and return dates with the length between them.
class TripBookingSummary extends StatelessWidget {
  const TripBookingSummary({super.key, required this.booking});

  final BookingTripModel booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TripInclusionsRow(),
        const Gap(8),
        Text(
          booking.title ?? '—',
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        if (booking.tripNumber != null) ...[
          const Gap(2),
          Text(
            booking.tripNumber!,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
        const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TripDateChip(
                labelKey: 'return_date',
                date: booking.endDate,
              ),
            ),
            const Gap(8),
            Expanded(child: TripDurationDivider(days: booking.durationDays)),
            const Gap(8),
            Expanded(
              child: TripDateChip(
                labelKey: 'departure',
                date: booking.startDate,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// "المبلغ المتبقي / 1200$" — the outstanding figure on a card in
/// "تحتاج دفعة".
class TripRemainingAmount extends StatelessWidget {
  const TripRemainingAmount({super.key, required this.booking});

  final BookingTripModel booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'remaining_amount'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const Gap(2),
        Text(
          booking.formattedRemaining,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
