import 'package:flutter/material.dart';
import 'package:skygate/core/components/dashed_line.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/journey_stop_column.dart';

/// Departure and arrival stops either side of the dashed arrow.
///
/// Shared by the itinerary card and the "تفاصيل القسم" summary; [showCode] is
/// what turns "جدة" into "جدة (JED)" on the detail screen.
class JourneyLegRow extends StatelessWidget {
  const JourneyLegRow({
    super.key,
    required this.from,
    required this.to,
    this.showCode = false,
  });

  final JourneyStopModel? from;
  final JourneyStopModel? to;
  final bool showCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: JourneyStopColumn(
            stop: from,
            showCode: showCode,
            alignment: CrossAxisAlignment.start,
          ),
        ),
        const _Connector(),
        Expanded(
          child: JourneyStopColumn(
            stop: to,
            showCode: showCode,
            alignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}

/// Dashed rule broken by the circular direction arrow.
class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 96,
      // Lines up with the city line rather than the taller time line.
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const Expanded(child: DashedLine()),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary),
              ),
              // The glyph always points the way the page reads.
              child: Transform.flip(
                flipX: Directionality.of(context) == TextDirection.rtl,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const Expanded(child: DashedLine()),
          ],
        ),
      ),
    );
  }
}
