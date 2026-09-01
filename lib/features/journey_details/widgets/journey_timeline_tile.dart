import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_line.dart';

/// One row of a vertical timeline: a glyph dot on the start side, a dotted
/// rail running down to the next row, and the row's card filling the rest.
///
/// Both the itinerary and the activities screen build on this, so the rail
/// keeps the same rhythm on either.
class JourneyTimelineTile extends StatelessWidget {
  const JourneyTimelineTile({
    super.key,
    required this.icon,
    required this.child,
    this.iconColor,
    this.dotColor,
    this.isLast = false,
  });

  final String icon;
  final Widget child;

  /// Glyph tint. Defaults to white, which is what the itinerary's solid dots
  /// need; the activity dots pass their kind's colour instead.
  final Color? iconColor;

  final Color? dotColor;

  /// Hides the rail below the dot on the final row.
  final bool isLast;

  static const double _railWidth = 46;
  static const double _dotSize = 34;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _railWidth,
            child: Column(
              children: [
                Container(
                  height: _dotSize,
                  width: _dotSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: dotColor ?? theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: AppImage(
                    icon,
                    height: 17,
                    width: 17,
                    color: iconColor ?? Colors.white,
                  ),
                ),
                if (!isLast)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: DashedLine(axis: Axis.vertical),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
