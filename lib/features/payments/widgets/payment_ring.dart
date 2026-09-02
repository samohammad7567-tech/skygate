import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The ring at the head of "ملخص المدفوعات": a pale track with the settled
/// share drawn over it and the whole percent printed inside.
///
/// The arc starts at twelve o'clock and sweeps clockwise whichever way the page
/// reads — a progress dial is not a directional glyph, so it must not mirror
/// under RTL.
class PaymentRing extends StatelessWidget {
  const PaymentRing({
    super.key,
    required this.ratio,
    required this.percent,
    this.size = 108,
  });

  /// Share of the total already paid, `0`–`1`.
  final double ratio;

  /// What the centre prints. Passed separately so the label never disagrees
  /// with a rounded arc.
  final int percent;

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: size,
      width: size,
      child: CustomPaint(
        painter: _RingPainter(
          ratio: ratio.clamp(0, 1).toDouble(),
          track: theme.colorScheme.surfaceContainerHighest,
          progress: theme.colorScheme.primary,
          stroke: size * 0.12,
        ),
        child: Center(
          child: Text(
            '$percent%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // A percentage reads left to right in Arabic too.
            textDirection: TextDirection.ltr,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: size * 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.ratio,
    required this.track,
    required this.progress,
    required this.stroke,
  });

  final double ratio;
  final Color track;
  final Color progress;
  final double stroke;

  static const double _start = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, 2 * math.pi, false, base);

    if (ratio <= 0) return;

    final filled = Paint()
      ..color = progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, 2 * math.pi * ratio, false, filled);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.ratio != ratio ||
      old.track != track ||
      old.progress != progress ||
      old.stroke != stroke;
}
