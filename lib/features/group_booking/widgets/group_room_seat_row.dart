import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/group_booking/models/group_room_seat.dart';
import 'package:skygate/core/components/audience_chip.dart';

class GroupRoomSeatRow extends StatelessWidget {
  const GroupRoomSeatRow({
    super.key,
    required this.seat,
    required this.position,
    required this.currency,
  });

  final GroupRoomSeat seat;
  final int position;

  final String? currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.s),
      child: Row(
        children: [
          PositionBadge(position: position, size: 28.s),
          Gap(10.s),
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
                      Gap(6.s),
                      const SecondInfantBadge(),
                    ],
                  ],
                ),
                Gap(4.s),
                AudienceChip(audience: seat.traveler.audience),
              ],
            ),
          ),
          Gap(10.s),
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
