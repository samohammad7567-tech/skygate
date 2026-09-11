import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/models/journey_transport.dart';

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
            // The leg under way is called out; the ones behind it are done and
            // the ones ahead have not started, and both read as inactive.
            isCurrent: current != null && i == current,
            isReached: current != null && i <= current,
          ),
          if (i < legs.length - 1)
            Expanded(
              child: Container(
                height: 2,
                color: current != null && i < current
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
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
  final bool isCurrent;
  final bool isReached;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final foreground = isCurrent
        ? theme.colorScheme.secondary
        : isReached
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.35);

    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCurrent
            ? theme.colorScheme.secondary.withValues(alpha: 0.18)
            : theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(color: foreground, width: 1.4),
      ),
      child: AppImage(
        transport.typeIcon,
        height: 15,
        width: 15,
        color: foreground,
      ),
    );
  }
}
