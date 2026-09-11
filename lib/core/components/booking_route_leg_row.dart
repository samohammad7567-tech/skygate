import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_line.dart';
import 'package:skygate/core/models/booking_route_model.dart';

class BookingRouteLegRow extends StatelessWidget {
  const BookingRouteLegRow({
    super.key,
    required this.leg,
    required this.glyphColor,
  });

  final BookingRouteLegModel leg;
  final Color glyphColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          AppImage(
            leg.transport.typeIcon,
            height: 22,
            width: 22,
            color: glyphColor,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              leg.from ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: _Arrow()),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              leg.to ?? '—',
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Expanded(child: DashedLine()),
        Transform.flip(
          flipX: Directionality.of(context) == TextDirection.rtl,
          child: Icon(
            Icons.play_arrow_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const Expanded(child: DashedLine()),
      ],
    );
  }
}
