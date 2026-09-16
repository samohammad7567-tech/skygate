import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';

class BookingRoomDetailsCard extends StatelessWidget {
  const BookingRoomDetailsCard({
    super.key,
    required this.room,
    required this.onDetails,
  });

  final BookingRoomDetailsModel room;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(counts: room.counts, onDetails: onDetails),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(labelKey: 'room_type', value: room.roomType),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_madinah_hotel',
                  value: room.madinahHotel,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_makkah_hotel',
                  value: room.makkahHotel,
                ),
                Divider(height: 1.s),
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

class _Header extends StatelessWidget {
  const _Header({required this.counts, required this.onDetails});

  final Map<TravelerAudience, int> counts;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 4.s),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: onDetails,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.secondary),
              padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 2.s),
              minimumSize: Size(0, 30.s),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.s),
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
          Gap(10.s),
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
