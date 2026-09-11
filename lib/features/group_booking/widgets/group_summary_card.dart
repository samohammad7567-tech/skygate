import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_grand_total.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';

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
  final Map<TravelerAudience, int> counts;

  final num grandTotal;
  final String? currency;
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
                AppGrandTotal(amount: '$grandTotal${currency ?? ''}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
