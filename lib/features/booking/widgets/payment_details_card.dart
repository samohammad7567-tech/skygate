import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';
import 'package:skygate/core/components/payment_detail_row.dart';

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
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13.s)),
            ),
            child: Text(
              'booking_details'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(
                  labelKey: 'summary_trip',
                  value: summary.tripTitle,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_route',
                  value: summary.routeName,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_type',
                  child: BookingTypeChip(
                    labelKey: summary.bookingType.labelKey,
                  ),
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'room_type',
                  value: summary.roomType,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_madinah_hotel',
                  value: summary.madinahHotel,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_makkah_hotel',
                  value: summary.makkahHotel,
                ),
                Divider(height: 1.s),
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
