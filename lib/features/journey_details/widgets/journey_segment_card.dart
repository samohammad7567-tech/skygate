import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/journey_duration_row.dart';
import 'package:skygate/features/journey_details/widgets/journey_leg_row.dart';

/// "القسم الأول" card on the itinerary timeline. Tapping it opens the leg's
/// own "تفاصيل القسم" screen.
class JourneySegmentCard extends StatelessWidget {
  const JourneySegmentCard({
    super.key,
    required this.segment,
    required this.position,
    this.onTap,
  });

  final JourneySegmentModel segment;

  /// 1-based place in the route, used for the "القسم الأول" title.
  final int position;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            segment.title ?? AppFormat.ordinalTitle('segment_title', position),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          JourneyLegRow(from: segment.from, to: segment.to),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          JourneyDurationRow(minutes: segment.durationMinutes),
        ],
      ),
    );
  }
}
