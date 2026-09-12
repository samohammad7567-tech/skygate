import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_line.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
  final Color? iconColor;

  final Color? dotColor;
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
                    height: 17.s,
                    width: 17.s,
                    color: iconColor ?? Colors.white,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.s),
                      child: DashedLine(axis: Axis.vertical),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 14.s),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
