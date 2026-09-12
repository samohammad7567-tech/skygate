import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_grand_total.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';
import 'package:skygate/features/payments/widgets/booking_room_details_card.dart';

class BookingDetailsCard extends StatelessWidget {
  const BookingDetailsCard({
    super.key,
    required this.details,
    required this.onRoomDetails,
  });

  final BookingDetailsModel details;
  final void Function(BookingRoomDetailsModel room) onRoomDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14.s, 14.s, 14.s, 14.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.s)),
            ),
            child: Text(
              'booking_details'.tr(),
              textAlign: TextAlign.end,
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
                  value: details.tripTitle,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_route',
                  value: details.routeName,
                ),
                Divider(height: 1.s),
                PaymentDetailRow(
                  labelKey: 'summary_type',
                  child: BookingTypeChip(
                    labelKey: details.type.labelKey,
                    // The design tints a group booking blue and an individual
                    // one orange.
                    color: details.isGroup ? theme.colorScheme.primary : null,
                  ),
                ),
                if (details.isGroup)
                  ..._group(context)
                else
                  ..._individual(context, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _individual(BuildContext context, ThemeData theme) {
    final room = details.singleRoom;

    return [
      Divider(height: 1.s),
      PaymentDetailRow(labelKey: 'room_type', value: room?.roomType),
      Divider(height: 1.s),
      PaymentDetailRow(
        labelKey: 'summary_madinah_hotel',
        value: room?.madinahHotel,
      ),
      Divider(height: 1.s),
      PaymentDetailRow(
        labelKey: 'summary_makkah_hotel',
        value: room?.makkahHotel,
      ),
      Divider(height: 1.s),
      PaymentDetailRow(
        labelKey: 'summary_final_total',
        value: '${details.total}${details.currency ?? ''}',
        valueColor: theme.colorScheme.secondary,
      ),
    ];
  }

  List<Widget> _group(BuildContext context) {
    return [
      Divider(height: 1.s),
      PaymentDetailRow(
        labelKey: 'summary_travelers',
        value: 'travelers_breakdown'.tr(
          namedArgs: {
            'adults': '${details.counts[TravelerAudience.adult] ?? 0}',
            'children': '${details.counts[TravelerAudience.child] ?? 0}',
            'infants': '${details.counts[TravelerAudience.infant] ?? 0}',
          },
        ),
      ),
      for (final room in details.rooms) ...[
        BookingRoomDetailsCard(
          room: room,
          onDetails: () => onRoomDetails(room),
        ),
        Gap(12.s),
      ],
      AppGrandTotal(
        amount: '${details.total}${details.currency ?? ''}',
        padding: EdgeInsets.only(bottom: 16.s),
        labelAlpha: 0.5,
        amountStyle: Theme.of(context).textTheme.titleLarge,
      ),
    ];
  }
}
