import 'package:flutter/material.dart';
import 'package:skygate/core/components/dashed_line.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/journey_stop_column.dart';

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

class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 96.s,
      child: Padding(
        padding: EdgeInsets.only(top: 10.s),
        child: Row(
          children: [
            const Expanded(child: DashedLine()),
            Container(
              height: 30.s,
              width: 30.s,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Transform.flip(
                flipX: Directionality.of(context) == TextDirection.rtl,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 18.s,
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
