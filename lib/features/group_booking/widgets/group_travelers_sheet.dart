import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/group_booking/models/group_room_seat.dart';
import 'package:skygate/features/group_booking/widgets/group_room_seat_row.dart';
import 'package:skygate/features/group_booking/widgets/group_sheet_handle.dart';

/// "تفاصيل المسافرون" — who is in one room and what each of them pays, opened
/// by the "التفاصيل" chip on the summary.
Future<void> showGroupTravelersSheet(
  BuildContext context, {
  required List<GroupRoomSeat> seats,
  required String? currency,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _TravelersSheet(seats: seats, currency: currency),
  );
}

class _TravelersSheet extends StatelessWidget {
  const _TravelersSheet({required this.seats, required this.currency});

  final List<GroupRoomSeat> seats;
  final String? currency;

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
            const GroupSheetHandle(),
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
                itemCount: seats.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) => GroupRoomSeatRow(
                  seat: seats[index],
                  position: index + 1,
                  currency: currency,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
