import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/components/room_beds_row.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_room_model.dart';
import 'package:skygate/features/group_booking/models/group_room_seat.dart';
import 'package:skygate/features/group_booking/widgets/group_add_traveler_button.dart';
import 'package:skygate/features/group_booking/widgets/group_price_row.dart';
import 'package:skygate/features/group_booking/widgets/group_room_card_header.dart';
import 'package:skygate/features/group_booking/widgets/group_room_seat_row.dart';

class GroupRoomCard extends StatelessWidget {
  const GroupRoomCard({
    super.key,
    required this.room,
    required this.seats,
    required this.total,
    required this.onAssign,
    required this.onDelete,
  });

  final GroupRoomModel room;
  final List<GroupRoomSeat> seats;

  final num total;
  final VoidCallback onAssign;

  final VoidCallback onDelete;

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
          GroupRoomCardHeader(
            room: room,
            onDelete: onDelete,
            onEdit: seats.isEmpty ? null : onAssign,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.s, 4.s, 14.s, 14.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (seats.isEmpty) ..._priceSheet() else ..._occupants(),
                if (room.price?.almostFull ?? false) ...[
                  Gap(10.s),
                  const Align(child: AlmostFullChip()),
                ],
                if (seats.isEmpty) ...[
                  Gap(12.s),
                  Align(
                    child: GroupAddTravelerButton(
                      onTap: onAssign,
                      filled: false,
                      labelKey: 'add_travelers',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _priceSheet() {
    final price = room.price;

    return [
      GroupPriceRow(
        asset: JourneyAssets.adult,
        labelKey: 'price_adult',
        price: price?.adultPrice,
        currency: room.currency,
      ),
      GroupPriceRow(
        asset: JourneyAssets.child,
        labelKey: 'price_child',
        price: price?.childPrice,
        currency: room.currency,
      ),
      GroupPriceRow(
        asset: JourneyAssets.infant,
        labelKey: 'price_infant',
        price: price?.infantPrice,
        currency: room.currency,
      ),
      GroupPriceRow(
        asset: JourneyAssets.infant,
        labelKey: 'price_second_infant',
        price: price?.secondInfantPrice,
        currency: room.currency,
      ),
      if (room.capacity > 1)
        GroupPriceRow(
          asset: JourneyAssets.bed,
          labelKey: 'lock_single_bed',
          price: price?.bedLockFee,
          currency: room.currency,
        ),
    ];
  }

  List<Widget> _occupants() => [
    for (var i = 0; i < seats.length; i++)
      GroupRoomSeatRow(
        seat: seats[i],
        position: i + 1,
        currency: room.currency,
      ),
    if (room.lockedBeds > 0)
      GroupPriceRow(
        asset: JourneyAssets.bed,
        labelKey: 'lock_beds',
        price: room.lockedBedsFee,
        currency: room.currency,
        count: room.lockedBeds,
      ),
    Divider(height: 18.s),
    GroupTotalRow(
      total: total,
      labelKey: 'room_final_total',
      currency: room.currency,
    ),
  ];
}
