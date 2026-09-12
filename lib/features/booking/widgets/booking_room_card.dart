import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking/models/room_type_model.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';
import 'package:skygate/core/components/room_beds_row.dart';

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
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13.s)),
            ),
            child: Row(
              children: [
                BookingRadio(isSelected: isSelected),
                Gap(12.s),
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
                      Gap(4.s),
                      RoomBedsRow(count: room.beds ?? 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoomPriceRow(price: room.adultPrice, currency: room.currency),
                if (room.almostFull) ...[
                  Gap(10.s),
                  Divider(height: 1.s),
                  Gap(10.s),
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
