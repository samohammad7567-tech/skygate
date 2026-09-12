import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/widgets/segment_instructions_card.dart';
import 'package:skygate/features/journey_details/widgets/segment_place_section.dart';
import 'package:skygate/features/journey_details/widgets/segment_summary_card.dart';
import 'package:skygate/features/journey_details/widgets/segment_vehicle_section.dart';

/// The "تفاصيل" tab of a segment: the leg's summary, the vehicle running it,
/// both ends of it, the route map, and the instructions that come with it.
class SegmentDetailsBody extends StatelessWidget {
  const SegmentDetailsBody({super.key, required this.segment});

  final JourneySegmentModel segment;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.s, 4.s, 20.s, 20.s),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentSummaryCard(segment: segment),
              Divider(height: 1.s),
              Padding(
                padding: EdgeInsets.fromLTRB(14.s, 14.s, 14.s, 16.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentVehicleSection(
                      transport: segment.transport,
                      vehicle: segment.vehicle,
                    ),
                    SizedBox(height: 18.s),
                    SegmentPlaceSection(
                      titleKey: 'departure_location_details',
                      place: segment.departurePlace,
                    ),
                    SizedBox(height: 16.s),
                    SegmentPlaceSection(
                      titleKey: 'arrival_location_details',
                      place: segment.arrivalPlace,
                    ),
                    SizedBox(height: 14.s),
                    // The route map export is 8:5; holding that ratio keeps
                    // the city labels on it from being cropped away.
                    AspectRatio(
                      aspectRatio: 8 / 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.s),
                        child: CachedImage(
                          url: segment.mapImage,
                          // Each mode of travel has its own drawing of the
                          // route; the plane's is not the ship's.
                          fallbackAsset: segment.transport.routeMap,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.s),
        SegmentInstructionsCard(instructions: segment.instructions),
      ],
    );
  }
}
