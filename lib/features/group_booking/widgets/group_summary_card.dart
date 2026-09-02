import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/core/models/traveler_audience.dart';

/// "تفاصيل الحجز" on the group summary: the trip, its route, the booking type
/// and the head count, then a block per room and the grand total.
class GroupSummaryCard extends StatelessWidget {
  const GroupSummaryCard({
    super.key,
    required this.tripTitle,
    required this.routeName,
    required this.counts,
    required this.grandTotal,
    required this.currency,
    required this.rooms,
  });

  final String? tripTitle;
  final String? routeName;

  /// Travellers on the booking per class.
  final Map<TravelerAudience, int> counts;

  final num grandTotal;
  final String? currency;

  /// One `GroupSummaryRoomCard` per room the group booked.
  final List<Widget> rooms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
            ),
            child: Text(
              'booking_details'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(labelKey: 'summary_trip', value: tripTitle),
                const Divider(height: 1),
                PaymentDetailRow(labelKey: 'summary_route', value: routeName),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_type',
                  child: BookingTypeChip(labelKey: BookingType.group.labelKey),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_travelers',
                  value: 'travelers_breakdown'.tr(
                    namedArgs: {
                      'adults': '${counts[TravelerAudience.adult] ?? 0}',
                      'children': '${counts[TravelerAudience.child] ?? 0}',
                      'infants': '${counts[TravelerAudience.infant] ?? 0}',
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final room in rooms) ...[room, const Gap(14)],
                _GrandTotal(total: grandTotal, currency: currency),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "المجموع النهائي لكل أنواع الغرف" closing the card.
class _GrandTotal extends StatelessWidget {
  const _GrandTotal({required this.total, required this.currency});

  final num total;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'grand_total_all_rooms'.tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const Gap(6),
        Text(
          '$total${currency ?? ''}',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
