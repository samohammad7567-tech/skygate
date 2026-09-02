import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';
import 'package:skygate/core/components/payment_detail_row.dart';

/// "تفاصيل الحجز" table on the summary step: one captioned row per field, with
/// the total printed in orange.
class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({super.key, required this.summary});

  final BookingSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = summary.total;

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
                PaymentDetailRow(
                  labelKey: 'summary_trip',
                  value: summary.tripTitle,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_route',
                  value: summary.routeName,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_type',
                  child: BookingTypeChip(
                    labelKey: summary.bookingType.labelKey,
                  ),
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'room_type',
                  value: summary.roomType,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_madinah_hotel',
                  value: summary.madinahHotel,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_makkah_hotel',
                  value: summary.makkahHotel,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_final_total',
                  value: total == null
                      ? null
                      : '$total${summary.currency ?? ''}',
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
