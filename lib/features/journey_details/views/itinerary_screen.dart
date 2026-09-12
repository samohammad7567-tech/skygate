import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/views/segment_details_screen.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/current_trip_card.dart';
import 'package:skygate/features/journey_details/widgets/journey_route_tabs.dart';
import 'package:skygate/features/journey_details/widgets/journey_segment_card.dart';
import 'package:skygate/features/journey_details/widgets/journey_timeline_tile.dart';

class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key, required this.tripId, this.bookingId});

  final int tripId;

  /// Set only when the route was opened from a booked trip. The segment's
  /// تأشيرات and تذاكر tabs need it to know whose documents to show.
  final int? bookingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JourneyDetailsCubit(tripId)
        ..getPackage()
        ..getRoutes(),
      child: _ItineraryBody(bookingId: bookingId),
    );
  }
}

class _ItineraryBody extends StatelessWidget {
  const _ItineraryBody({required this.bookingId});

  final int? bookingId;

  Color _dotColor(int index) =>
      index.isEven ? AppColors.primaryDark : AppColors.accent;

  void _openSegment(BuildContext context, JourneySegmentModel segment) {
    NaivgatorHelper.pushNavigation(
      context,
      SegmentDetailsScreen(
        tripId: context.read<JourneyDetailsCubit>().tripId,
        segment: segment,
        bookingId: bookingId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The header sits outside the scroll area on purpose: the way back has
      // to stay reachable however far down the route the reader has got.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 0),
              child: AppTitleHeader(showBack: true),
            ),
            Expanded(child: _content(context)),
          ],
        ),
      ),
      // "متابعة الحجز والدفع" belongs to a trip being bought. Reached from
      // "رحلاتي" the trip is already the pilgrim's, and the design ends the
      // route on the last leg rather than on a call to action.
      bottomNavigationBar: bookingId != null
          ? null
          : JourneyBottomBar(
              label: 'continue_booking_payment'.tr(),
              onPressed: () => NaivgatorHelper.popNavigation(context),
            ),
    );
  }

  Widget _content(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
      builder: (context, state) {
        final cubit = context.read<JourneyDetailsCubit>();
        final segments = cubit.selectedRoute?.segments ?? const [];

        return ListView(
          padding: EdgeInsets.only(bottom: 12.s),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 0),
              child: CurrentTripCard(package: cubit.package),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 20.s, 20.s, 12.s),
              child: Text(
                'trip_route'.tr(),
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
            SizedBox(height: 12.s),
            if (state is RoutesLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60.s),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BuildCondition(
                condition: segments.isNotEmpty,
                builder: (_) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.s),
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
                  padding: EdgeInsets.symmetric(vertical: 60.s),
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
    );
  }
}
