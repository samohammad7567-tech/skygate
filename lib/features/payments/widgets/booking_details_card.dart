import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/components/payment_detail_row.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';
import 'package:skygate/features/payments/widgets/booking_grand_total.dart';
import 'package:skygate/features/payments/widgets/booking_room_details_card.dart';

/// "تفاصيل الحجز" — the read-only review of one booking.
///
/// An individual booking prints its single room's fields straight into the
/// table; a group booking prints the head counts instead and gives each room a
/// card of its own, with the grand total under the lot.
class BookingDetailsCard extends StatelessWidget {
  const BookingDetailsCard({
    super.key,
    required this.details,
    required this.onRoomDetails,
  });

  final BookingDetailsModel details;

  /// Opens "تفاصيل المسافرين" for one room of a group booking.
  final void Function(BookingRoomDetailsModel room) onRoomDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDetailRow(
                  labelKey: 'summary_trip',
                  value: details.tripTitle,
                ),
                const Divider(height: 1),
                PaymentDetailRow(
                  labelKey: 'summary_route',
                  value: details.routeName,
                ),
                const Divider(height: 1),
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

  /// The single room's fields, printed inline under "النوع".
  List<Widget> _individual(BuildContext context, ThemeData theme) {
    final room = details.singleRoom;

    return [
      const Divider(height: 1),
      PaymentDetailRow(labelKey: 'room_type', value: room?.roomType),
      const Divider(height: 1),
      PaymentDetailRow(
        labelKey: 'summary_madinah_hotel',
        value: room?.madinahHotel,
      ),
      const Divider(height: 1),
      PaymentDetailRow(
        labelKey: 'summary_makkah_hotel',
        value: room?.makkahHotel,
      ),
      const Divider(height: 1),
      PaymentDetailRow(
        labelKey: 'summary_final_total',
        value: '${details.total}${details.currency ?? ''}',
        valueColor: theme.colorScheme.secondary,
      ),
    ];
  }

  /// The head counts, one card per room, then the grand total.
  List<Widget> _group(BuildContext context) {
    return [
      const Divider(height: 1),
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
        const Gap(12),
      ],
      BookingGrandTotal(amount: '${details.total}${details.currency ?? ''}'),
    ];
  }
}
