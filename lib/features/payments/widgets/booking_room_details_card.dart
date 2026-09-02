import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';

/// One room block inside "تفاصيل الحجز" for a group booking: who sleeps in it,
/// its size, the hotel it takes in each city and what it cost.
class BookingRoomDetailsCard extends StatelessWidget {
  const BookingRoomDetailsCard({
    super.key,
    required this.room,
    required this.onDetails,
  });

  final BookingRoomDetailsModel room;

  /// Opens "تفاصيل المسافرين" for this room.
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
          _Header(counts: room.counts, onDetails: onDetails),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(labelKey: 'room_type', value: room.roomType),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_madinah_hotel',
                  value: room.madinahHotel,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_makkah_hotel',
                  value: room.makkahHotel,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_final_total',
                  value: room.total == null
                      ? null
                      : '${room.total}${room.currency ?? ''}',
                  valueColor: theme.colorScheme.primary,
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
          const Gap(10),
          Expanded(
            child: Text(
              'travelers_breakdown'.tr(
                namedArgs: {
                  'adults': '${counts[TravelerAudience.adult] ?? 0}',
                  'children': '${counts[TravelerAudience.child] ?? 0}',
                  'infants': '${counts[TravelerAudience.infant] ?? 0}',
                },
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
