import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rounded rectangle with a dashed outline — the drop zone used by the profile
/// photo picker and by every "ملفات المعتمر" card.
class DashedBox extends StatelessWidget {
  const DashedBox({
    super.key,
    required this.child,
    this.radius = 14,
    this.color,
    this.fillColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    this.onTap,
  });

  final Widget child;
  final double radius;
  final Color? color;
  final Color? fillColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(radius);

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color ?? theme.colorScheme.primary,
        radius: radius,
      ),
      child: Material(
        color: fillColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(
            padding: padding,
            child: SizedBox(width: double.infinity, child: child),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _dash = 6;
  static const double _gap = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + _dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
