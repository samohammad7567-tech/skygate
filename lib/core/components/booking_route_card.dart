import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/models/booking_route_model.dart';
import 'package:skygate/core/components/booking_route_leg_row.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';
import 'package:skygate/core/utils/app_scale.dart';

class BookingRouteCard extends StatelessWidget {
  const BookingRouteCard({
    super.key,
    required this.route,
    required this.position,
    required this.isSelected,
    required this.onTap,
  });

  final BookingRouteModel route;
  final int position;

  final bool isSelected;
  final VoidCallback onTap;
  Color _glyphColor(int index) =>
      index.isEven ? AppColors.primary : AppColors.accent;

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
            padding: EdgeInsets.fromLTRB(14.s, 10.s, 14.s, 10.s),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
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
                        '${route.title ?? AppFormat.ordinalTitle('route_title', position)}:',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        route.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.s, 2.s, 14.s, 8.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < route.legs.length; i++)
                  BookingRouteLegRow(
                    leg: route.legs[i],
                    glyphColor: _glyphColor(i),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
