import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/audience_chip.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';

Future<void> showBookingTravelersSheet(
  BuildContext context, {
  required List<BookingTravelerModel> travelers,
}) {
  return showAppSheet<void>(
    context,
    builder: (_) => _TravelersSheet(travelers: travelers),
  );
}

class _TravelersSheet extends StatelessWidget {
  const _TravelersSheet({required this.travelers});

  final List<BookingTravelerModel> travelers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 16.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Gap(14.s),
            Text(
              'travelers_details'.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Gap(12.s),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: travelers.length,
                separatorBuilder: (_, _) => Divider(height: 1.s),
                itemBuilder: (_, index) => _TravelerRow(
                  traveler: travelers[index],
                  position: index + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelerRow extends StatelessWidget {
  const _TravelerRow({required this.traveler, required this.position});

  final BookingTravelerModel traveler;
  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.s),
      child: Row(
        children: [
          Text(
            traveler.formattedPrice,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          Gap(10.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  traveler.name,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Gap(4.s),
                AudienceChip(audience: traveler.audience),
              ],
            ),
          ),
          Gap(10.s),
          PositionBadge(position: position, size: 28.s),
        ],
      ),
    );
  }
}
