import 'package:flutter/material.dart';

/// Dotted rule used by the timeline rails and either side of a leg's arrow.
///
/// It paints rather than laying out a run of boxes, so it keeps working inside
/// an [IntrinsicHeight] — which is exactly where the timeline puts it.
class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.axis = Axis.horizontal,
    this.color,
    this.dash = 4,
    this.gap = 4,
    this.thickness = 1.4,
  });

  final Axis axis;
  final Color? color;
  final double dash;
  final double gap;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHorizontal = axis == Axis.horizontal;

    return SizedBox(
      height: isHorizontal ? thickness : null,
      width: isHorizontal ? null : thickness,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DashedLinePainter(
          axis: axis,
          color: color ?? theme.colorScheme.outlineVariant,
          dash: dash,
          gap: gap,
          thickness: thickness,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({
    required this.axis,
    required this.color,
    required this.dash,
    required this.gap,
    required this.thickness,
  });

  final Axis axis;
  final Color color;
  final double dash;
  final double gap;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final isHorizontal = axis == Axis.horizontal;
    final extent = isHorizontal ? size.width : size.height;
    if (extent <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final cross = isHorizontal ? size.height / 2 : size.width / 2;

    for (var start = 0.0; start < extent; start += dash + gap) {
      final end = (start + dash).clamp(0.0, extent);
      canvas.drawLine(
        isHorizontal ? Offset(start, cross) : Offset(cross, start),
        isHorizontal ? Offset(end, cross) : Offset(cross, end),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.axis != axis ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap ||
      oldDelegate.thickness != thickness;
}
