import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
  final bool isCurrent;
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
