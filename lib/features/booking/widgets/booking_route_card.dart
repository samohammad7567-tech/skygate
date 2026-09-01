import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/booking/models/booking_route_model.dart';
import 'package:skygate/features/booking/widgets/booking_route_leg_row.dart';
import 'package:skygate/features/booking/widgets/booking_selectable_card.dart';

/// One card on "اختر المسار": the tinted title strip with the radio, then a
/// row per leg.
class BookingRouteCard extends StatelessWidget {
  const BookingRouteCard({
    super.key,
    required this.route,
    required this.position,
    required this.isSelected,
    required this.onTap,
  });

  final BookingRouteModel route;

  /// 1-based place in the list, used for the "المسار الأول" caption.
  final int position;

  final bool isSelected;
  final VoidCallback onTap;

  /// The legs alternate between the two brand colours, exactly as the design
  /// prints them.
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
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
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
            padding: const EdgeInsets.fromLTRB(14, 2, 14, 8),
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
