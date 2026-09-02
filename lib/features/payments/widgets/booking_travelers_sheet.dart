import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/audience_chip.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';

/// "تفاصيل المسافرين" — who is in one room and what each of them paid, opened
/// by the "التفاصيل" chip on a room card.
Future<void> showBookingTravelersSheet(
  BuildContext context, {
  required List<BookingTravelerModel> travelers,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            const Gap(14),
            Text(
              'travelers_details'.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const Gap(12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: travelers.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
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

/// One line: the place badge, the traveller with their class chip, then what
/// their seat cost.
class _TravelerRow extends StatelessWidget {
  const _TravelerRow({required this.traveler, required this.position});

  final BookingTravelerModel traveler;
  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
          const Gap(10),
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
                const Gap(4),
                AudienceChip(audience: traveler.audience),
              ],
            ),
          ),
          const Gap(10),
          PositionBadge(position: position, size: 28),
        ],
      ),
    );
  }
}
