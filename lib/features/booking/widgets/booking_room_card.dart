import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/booking/models/room_type_model.dart';
import 'package:skygate/features/booking/widgets/booking_selectable_card.dart';
import 'package:skygate/features/booking/widgets/room_beds_row.dart';

/// One card on "اختر نوع الغرفة": the tinted title strip with a bed per
/// sleeper, then the adult price and the "شارفت على الانتهاء" warning.
class BookingRoomCard extends StatelessWidget {
  const BookingRoomCard({
    super.key,
    required this.room,
    required this.isSelected,
    required this.onTap,
  });

  final RoomTypeModel room;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BookingSelectableCard(
      isSelected: isSelected,
      onTap: onTap,
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
            child: Row(
              children: [
                BookingRadio(isSelected: isSelected),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        room.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      const Gap(4),
                      RoomBedsRow(count: room.beds ?? 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoomPriceRow(price: room.adultPrice, currency: room.currency),
                if (room.almostFull) ...[
                  const Gap(10),
                  const Divider(height: 1),
                  const Gap(10),
                  const Align(child: AlmostFullChip()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
