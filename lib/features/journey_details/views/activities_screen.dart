import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/activity_legend_bar.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/controller/cubit/activities_cubit.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/views/activities_search_screen.dart';
import 'package:skygate/features/journey_details/widgets/activity_card.dart';
import 'package:skygate/features/journey_details/widgets/activity_day_tabs.dart';
import 'package:skygate/features/journey_details/widgets/activity_details_sheet.dart';
import 'package:skygate/features/journey_details/widgets/activity_rating_sheet.dart';
import 'package:skygate/features/journey_details/widgets/current_trip_card.dart';
import 'package:skygate/features/journey_details/widgets/journey_timeline_tile.dart';

/// "جدول اليوم" — the running trip's programme, one day at a time.
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key, this.tripId});

  final int? tripId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ActivitiesCubit(tripId: tripId)..getActivities(),
        ),
        // The header card is the trip's, not the day's, so the schedule reads
        // it from the package the same way the other two screens do.
        if (tripId != null)
          BlocProvider(
            create: (_) => JourneyDetailsCubit(tripId!)..getPackage(),
          ),
      ],
      child: _ActivitiesBody(hasTrip: tripId != null),
    );
  }
}

class _ActivitiesBody extends StatelessWidget {
  const _ActivitiesBody({required this.hasTrip});

  final bool hasTrip;

  /// A card's button does one of two things depending on where the activity
  /// has got to: check the pilgrim in, or collect their rating.
  void _act(BuildContext context, ActivityModel activity) {
    final cubit = context.read<ActivitiesCubit>();

    if (activity.action == ActivityAction.rate) {
      ActivityRatingSheet.show(
        context,
        activity: activity,
        onSubmit: (rating, comment) =>
            cubit.submitFeedback(activity, rating: rating, comment: comment),
      );
      return;
    }
    cubit.confirmAttendance(activity);
  }

  void _open(BuildContext context, ActivityModel activity) {
    final cubit = context.read<ActivitiesCubit>();

    ActivityDetailsSheet.show(
      context,
      activity: activity,
      onConfirm: activity.action == ActivityAction.confirmAttendance
          ? () => cubit.confirmAttendance(activity)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<ActivitiesCubit, ActivitiesState>(
          listenWhen: (_, state) =>
              state is AttendanceConfirmed ||
              state is FeedbackSubmitted ||
              state is ActivityActionFailed,
          listener: (context, state) => switch (state) {
            AttendanceConfirmed() => showToast(
              context,
              'attendance_confirmed'.tr(),
            ),
            FeedbackSubmitted() => showToast(context, 'rating_sent'.tr()),
            ActivityActionFailed() => showToast(
              context,
              state.message.tr(),
              isError: true,
            ),
            _ => null,
          },
          builder: (context, state) {
            final cubit = context.read<ActivitiesCubit>();

            return Column(
              children: [
                // Always reachable, whether or not the trip header is drawn:
                // this screen is only ever pushed, never a tab root.
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 0),
                  child: AppTitleHeader(showBack: true),
                ),
                if (hasTrip) const _TripHeader(),
                ActivityDayTabs(
                  days: cubit.days,
                  selectedIndex: cubit.selectedDayIndex,
                  todayIndex: cubit.todayIndex,
                  onSelected: cubit.selectDay,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 10.s),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'day_schedule'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      // The day being shown, named plainly beside the
                      // heading — the design prints it, it does not tap.
                      Text(
                        _dayLabel(cubit) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _body(context, state, cubit)),
                ActivityLegendBar(kinds: cubit.legend),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 12.s),
          child: CustomButton(
            label: 'search_for_activities'.tr(),
            height: 48.s,
            width: double.infinity,
            onPressed: () => _openSearch(context),
          ),
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) => NaivgatorHelper.pushNavigation(
    context,
    BlocProvider.value(
      value: context.read<ActivitiesCubit>(),
      child: const ActivitiesSearchScreen(),
    ),
  );

  String? _dayLabel(ActivitiesCubit cubit) {
    final day = cubit.selectedDay;
    return day == null ? null : '${'day'.tr()} ${day.number}';
  }

  Widget _body(
    BuildContext context,
    ActivitiesState state,
    ActivitiesCubit cubit,
  ) {
    if (state is ActivitiesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final activities = cubit.visibleActivities;

    return BuildCondition(
      condition: activities.isNotEmpty,
      builder: (_) => ListView(
        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 8.s),
        children: [
          for (var i = 0; i < activities.length; i++)
            JourneyTimelineTile(
              icon: activities[i].kind.icon,
              dotColor: activities[i].surfaceColor,
              iconColor: activities[i].accentColor,
              isLast: i == activities.length - 1,
              child: ActivityCard(
                activity: activities[i],
                isBusy: cubit.busyActivityId == activities[i].id,
                onTap: () => _open(context, activities[i]),
                onAction: () => _act(context, activities[i]),
              ),
            ),
        ],
      ),
      fallback: (_) => EmptyState(
        message: state is ActivitiesError
            ? state.message.tr()
            : 'no_activities'.tr(),
        onRetry: () => cubit.getActivities(refresh: true),
      ),
    );
  }
}

class _TripHeader extends StatelessWidget {
  const _TripHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
      builder: (context, _) => Padding(
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 4.s),
        child: CurrentTripCard(
          package: context.read<JourneyDetailsCubit>().package,
        ),
      ),
    );
  }
}
