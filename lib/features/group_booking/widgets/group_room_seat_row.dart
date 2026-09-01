import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/group_booking/models/group_room_seat.dart';
import 'package:skygate/features/group_booking/widgets/group_audience_chip.dart';

/// One line of a filled room card: the seat number, the traveller with their
/// class chip, then the price they pay in that room.
class GroupRoomSeatRow extends StatelessWidget {
  const GroupRoomSeatRow({
    super.key,
    required this.seat,
    required this.position,
    required this.currency,
  });

  final GroupRoomSeat seat;

  /// 1-based place inside the room.
  final int position;

  final String? currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          GroupPositionBadge(position: position, size: 28),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        seat.traveler.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    if (seat.isSecondInfant) ...[
                      const Gap(6),
                      const GroupSecondInfantBadge(),
                    ],
                  ],
                ),
                const Gap(4),
                GroupAudienceChip(audience: seat.traveler.audience),
              ],
            ),
          ),
          const Gap(10),
          Text(
            '${seat.price}${currency ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
