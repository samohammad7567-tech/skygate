import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/views/segment_details_screen.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/journey_hero_header.dart';
import 'package:skygate/features/journey_details/widgets/journey_route_tabs.dart';
import 'package:skygate/features/journey_details/widgets/journey_segment_card.dart';
import 'package:skygate/features/journey_details/widgets/journey_timeline_tile.dart';

/// "مسارات الرحلة" — route tabs over a timeline of the selected route's legs.
class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JourneyDetailsCubit(tripId)
        ..getPackage()
        ..getRoutes(),
      child: const _ItineraryBody(),
    );
  }
}

class _ItineraryBody extends StatelessWidget {
  const _ItineraryBody();

  /// The rail alternates between the two brand colours, exactly as the design
  /// prints it, so neighbouring legs stay easy to tell apart.
  Color _dotColor(int index) =>
      index.isEven ? AppColors.primaryDark : AppColors.accent;

  void _openSegment(BuildContext context, JourneySegmentModel segment) {
    NaivgatorHelper.pushNavigation(
      context,
      SegmentDetailsScreen(
        tripId: context.read<JourneyDetailsCubit>().tripId,
        segment: segment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
        builder: (context, state) {
          final cubit = context.read<JourneyDetailsCubit>();
          final segments = cubit.selectedRoute?.segments ?? const [];

          return ListView(
            padding: const EdgeInsets.only(bottom: 12),
            children: [
              JourneyHeroHeader(
                image: cubit.package?.image,
                durationDays: cubit.package?.durationDays,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  cubit.package?.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              JourneyRouteTabs(
                routes: cubit.routes,
                selectedIndex: cubit.selectedRouteIndex,
                onSelected: cubit.selectRoute,
              ),
              const SizedBox(height: 16),
              if (state is RoutesLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                BuildCondition(
                  condition: segments.isNotEmpty,
                  builder: (_) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < segments.length; i++)
                          JourneyTimelineTile(
                            icon: segments[i].transport.typeIcon,
                            dotColor: _dotColor(i),
                            isLast: i == segments.length - 1,
                            child: JourneySegmentCard(
                              segment: segments[i],
                              position: i + 1,
                              onTap: () => _openSegment(context, segments[i]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  fallback: (_) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: EmptyState(
                      message: state is RoutesError
                          ? state.message.tr()
                          : 'no_routes'.tr(),
                      onRetry: cubit.getRoutes,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: JourneyBottomBar(
        label: 'continue_booking_payment'.tr(),
        onPressed: () => NaivgatorHelper.popNavigation(context),
      ),
    );
  }
}
