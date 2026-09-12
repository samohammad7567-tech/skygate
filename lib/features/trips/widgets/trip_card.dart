import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';
import 'package:skygate/features/trips/widgets/trip_chips.dart';
import 'package:skygate/features/trips/widgets/trip_progress_rail.dart';
import 'package:skygate/features/trips/widgets/trip_summary.dart';

/// One row of "رحلاتي": the trip's photo and standing on the outer edge, its
/// name, number and dates beside them, the legs it is made of underneath, and
/// the way into its details at the foot.
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.tab,
    required this.onDetails,
  });

  final TripModel trip;
  final TripsTab tab;
  final VoidCallback onDetails;

  /// The badge repeats what `filter_status` said about this trip, and only
  /// falls back to the tab when the API left the field out.
  TripsTab get _status => TripsTab.fromApi(trip.filterStatus) ?? tab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: TripSummary(trip: trip)),
                const Gap(10),
                _Photo(url: trip.imageUrl, status: _status),
              ],
            ),
          ),
          // `my-trips` sends the legs as modes only, and sends none at all for
          // a trip whose itinerary is not published yet.
          if (trip.transportModes.isNotEmpty) ...[
            const Gap(10),
            // Ruled off level with the photo's edge, not across the whole card.
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 134),
              child: Divider(height: 1, color: theme.colorScheme.outline),
            ),
            const Gap(12),
            TripProgressRail(
              legs: trip.transportModes,
              currentLeg: trip.currentLeg,
            ),
          ],
          const Gap(12),
          CustomButton(
            label: 'view_details'.tr(),
            height: 42,
            width: double.infinity,
            onPressed: onDetails,
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.url, required this.status});

  final String? url;
  final TripsTab status;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          // `trip_image_url` is null on every demo trip, so the bundled photo
          // is what most cards still draw.
          child: CachedImage(
            url: url,
            fallbackAsset: HomeAssets.kaaba,
            height: 104,
            width: 124,
          ),
        ),
        // The outer corner of the photo — the side away from the text.
        PositionedDirectional(
          top: 6,
          end: 6,
          child: TripStatusChip(tab: status),
        ),
      ],
    );
  }
}
