import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class MapDashedRing extends StatelessWidget {
  const MapDashedRing({
    super.key,
    required this.child,
    this.size,
    this.color,
    this.fill,
  });

  final Widget child;
  final double? size;
  final Color? color;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: (size ?? 180.s),
      width: (size ?? 180.s),
      child: CustomPaint(
        painter: _DashedRingPainter(
          color: color ?? theme.colorScheme.outlineVariant,
          fill: fill,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  _DashedRingPainter({required this.color, this.fill});

  final Color color;
  final Color? fill;
  static const double _dash = 4.2;
  static const double _gap = 3.4;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2 - 1;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    final wash = fill;
    if (wash != null) {
      canvas.drawCircle(rect.center, radius, Paint()..color = wash);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const step = (_dash + _gap) * math.pi / 180;
    const sweep = _dash * math.pi / 180;
    for (double angle = 0; angle < 2 * math.pi; angle += step) {
      canvas.drawArc(rect, angle, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) =>
      old.color != color || old.fill != fill;
}
