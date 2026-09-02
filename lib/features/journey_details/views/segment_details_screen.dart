import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/views/activities_screen.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/segment_instructions_card.dart';
import 'package:skygate/features/journey_details/widgets/segment_place_section.dart';
import 'package:skygate/features/journey_details/widgets/segment_summary_card.dart';
import 'package:skygate/features/journey_details/widgets/segment_vehicle_section.dart';

/// "تفاصيل القسم" — one leg of a route: carrier, vehicle, both terminals and
/// the instructions that come with it.
class SegmentDetailsScreen extends StatelessWidget {
  const SegmentDetailsScreen({
    super.key,
    required this.tripId,
    required this.segment,
  });

  final int tripId;

  /// The leg as the itinerary knows it — which is everything the API
  /// publishes about it.
  final JourneySegmentModel segment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JourneyDetailsCubit(tripId)..showSegment(segment),
      child: const _SegmentDetailsBody(),
    );
  }
}

class _SegmentDetailsBody extends StatelessWidget {
  const _SegmentDetailsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
          builder: (context, state) {
            final segment = context.read<JourneyDetailsCubit>().segment;

            return Column(
              children: [
                AppPageHeader(title: 'section_details'.tr()),
                Expanded(
                  child: segment == null
                      ? const Center(child: CircularProgressIndicator())
                      : _SegmentContent(segment: segment),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: JourneyBottomBar(
        label: 'go_to_activities'.tr(),
        onPressed: () =>
            NaivgatorHelper.pushNavigation(context, const ActivitiesScreen()),
      ),
    );
  }
}

class _SegmentContent extends StatelessWidget {
  const _SegmentContent({required this.segment});

  final JourneySegmentModel segment;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentSummaryCard(segment: segment),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentVehicleSection(
                      transport: segment.transport,
                      vehicle: segment.vehicle,
                    ),
                    const SizedBox(height: 18),
                    SegmentPlaceSection(
                      titleKey: 'departure_location_details',
                      place: segment.departurePlace,
                    ),
                    const SizedBox(height: 16),
                    SegmentPlaceSection(
                      titleKey: 'arrival_location_details',
                      place: segment.arrivalPlace,
                    ),
                    const SizedBox(height: 14),
                    // The route map export is 8:5; holding that ratio keeps
                    // the city labels on it from being cropped away.
                    AspectRatio(
                      aspectRatio: 8 / 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedImage(
                          url: segment.mapImage,
                          fallbackAsset: JourneyAssets.routeMap,
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
        const SizedBox(height: 14),
        SegmentInstructionsCard(instructions: segment.instructions),
      ],
    );
  }
}
