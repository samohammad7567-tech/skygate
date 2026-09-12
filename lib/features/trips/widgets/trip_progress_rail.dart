import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// The strip of plates across a "رحلاتي" card: one per leg, in the order they
/// are travelled, joined by the line between them.
///
/// Three standings, each an outlined circle on the card's own ground: legs
/// already travelled ring in blue, the leg under way rings in gold, and the
/// ones still ahead ring in grey. The joint behind a travelled leg is drawn
/// heavy and blue, the rest hairline and pale.
///
/// [currentLeg] is the leg under way. `my-trips` sends the legs as modes only
/// and says nothing about progress, so the rail is usually drawn without one —
/// it then states the route, every plate ringed in blue and every joint pale.
class TripProgressRail extends StatelessWidget {
  const TripProgressRail({super.key, required this.legs, this.currentLeg});

  final List<JourneyTransport> legs;
  final int? currentLeg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = currentLeg;

    return Row(
      children: [
        for (var i = 0; i < legs.length; i++) ...[
          _Plate(
            transport: legs[i],
            isCurrent: current != null && i == current,
            isReached: current == null || i < current,
          ),
          if (i < legs.length - 1)
            Expanded(
              child: Container(
                // The stretch already travelled is stated; the rest is only
                // ruled in, so it stays out of the way.
                height: current != null && i < current ? 3 : 1.5,
                color: current != null && i < current
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
        ],
      ],
    );
  }
}

class _Plate extends StatelessWidget {
  const _Plate({
    required this.transport,
    required this.isCurrent,
    required this.isReached,
  });

  final JourneyTransport transport;

  /// The leg under way — the only one drawn in gold, and the only one whose
  /// ring is thickened.
  final bool isCurrent;

  /// A leg already behind the traveller, and every leg when progress is
  /// unknown: the rail then reads as the route rather than as nothing done.
  final bool isReached;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final foreground = isCurrent
        ? theme.colorScheme.secondary
        : isReached
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return Container(
      height: 32.s,
      width: 32.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: foreground, width: isCurrent ? 2.4 : 1.6),
      ),
      child: AppImage(
        transport.typeIcon,
        height: 16.s,
        width: 16.s,
        color: foreground,
      ),
    );
  }
}
