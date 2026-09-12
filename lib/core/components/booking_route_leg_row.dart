import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_line.dart';
import 'package:skygate/core/models/booking_route_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
      padding: EdgeInsets.symmetric(vertical: 10.s),
      child: Row(
        children: [
          AppImage(
            leg.transport.typeIcon,
            height: 22.s,
            width: 22.s,
            color: glyphColor,
          ),
          SizedBox(width: 10.s),
          Flexible(
            child: Text(
              leg.from ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
          ),
          SizedBox(width: 8.s),
          const Expanded(child: _Arrow()),
          SizedBox(width: 8.s),
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
            size: 16.s,
            color: theme.colorScheme.primary,
          ),
        ),
        const Expanded(child: DashedLine()),
      ],
    );
  }
}
