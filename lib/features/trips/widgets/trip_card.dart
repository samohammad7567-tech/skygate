import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';
import 'package:skygate/features/trips/widgets/trip_chips.dart';
import 'package:skygate/features/trips/widgets/trip_progress_rail.dart';
import 'package:skygate/features/trips/widgets/trip_summary.dart';

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
  TripsTab get _status => TripsTab.fromApi(trip.filterStatus) ?? tab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
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
                Gap(10.s),
                _Photo(url: trip.imageUrl, status: _status),
              ],
            ),
          ),
          if (trip.transportModes.isNotEmpty) ...[
            Gap(10.s),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 134.s),
              child: Divider(height: 1.s, color: theme.colorScheme.outline),
            ),
            Gap(12.s),
            TripProgressRail(
              legs: trip.transportModes,
              currentLeg: trip.currentLeg,
            ),
          ],
          Gap(12.s),
          CustomButton(
            label: 'view_details'.tr(),
            height: 42.s,
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
          borderRadius: BorderRadius.circular(12.s),
          child: CachedImage(
            url: url,
            fallbackAsset: HomeAssets.kaaba,
            height: 104.s,
            width: 124.s,
          ),
        ),
        PositionedDirectional(
          top: 6.s,
          end: 6.s,
          child: TripStatusChip(tab: status),
        ),
      ],
    );
  }
}
