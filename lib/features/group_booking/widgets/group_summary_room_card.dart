import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/features/group_booking/models/group_room_model.dart';
import 'package:skygate/core/models/traveler_audience.dart';

/// One room block on "ملخص الحجز": who sleeps in it, the size, the hotel it
/// takes in each city and what the room costs.
class GroupSummaryRoomCard extends StatelessWidget {
  const GroupSummaryRoomCard({
    super.key,
    required this.room,
    required this.counts,
    required this.hotelNames,
    required this.total,
    required this.currency,
    required this.onDetails,
  });

  final GroupRoomModel room;

  /// Travellers in the room per class, printed in the header.
  final Map<TravelerAudience, int> counts;

  /// The hotel the room takes in each city.
  final Map<BookingCity, String?> hotelNames;

  final num total;
  final String? currency;

  /// Opens "تفاصيل المسافرون" for this room.
  final VoidCallback onDetails;

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
          _Header(counts: counts, onDetails: onDetails),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(
                  labelKey: 'room_type',
                  value: room.type.labelKey.tr(),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_madinah_hotel',
                  value: hotelNames[BookingCity.madinah],
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_makkah_hotel',
                  value: hotelNames[BookingCity.makkah],
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_final_total',
                  value: '$total${currency ?? ''}',
                  valueColor: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "1 بالغ - 2 طفل - 1 رضيع" with the orange "التفاصيل" chip after it.
class _Header extends StatelessWidget {
  const _Header({required this.counts, required this.onDetails});

  final Map<TravelerAudience, int> counts;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'travelers_breakdown'.tr(
                namedArgs: {
                  'adults': '${counts[TravelerAudience.adult] ?? 0}',
                  'children': '${counts[TravelerAudience.child] ?? 0}',
                  'infants': '${counts[TravelerAudience.infant] ?? 0}',
                },
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const Gap(10),
          OutlinedButton(
            onPressed: onDetails,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.secondary),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              minimumSize: const Size(0, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'details'.tr(),
              maxLines: 1,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
