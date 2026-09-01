import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/features/journey_details/controller/cubit/activities_cubit.dart';
import 'package:skygate/features/journey_details/models/activity_model.dart';
import 'package:skygate/features/journey_details/widgets/activity_card.dart';
import 'package:skygate/features/journey_details/widgets/activity_day_tabs.dart';
import 'package:skygate/features/journey_details/widgets/activity_legend_bar.dart';
import 'package:skygate/features/journey_details/widgets/journey_timeline_tile.dart';

/// "تفاصيل الأنشطة" — day tabs over the selected day's programme.
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivitiesCubit()..getActivities(),
      child: const _ActivitiesBody(),
    );
  }
}

class _ActivitiesBody extends StatelessWidget {
  const _ActivitiesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ActivitiesCubit, ActivitiesState>(
          builder: (context, state) {
            final cubit = context.read<ActivitiesCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'activities_details'.tr()),
                ActivityDayTabs(
                  days: cubit.days,
                  selectedIndex: cubit.selectedDayIndex,
                  todayIndex: cubit.todayIndex,
                  onSelected: cubit.selectDay,
                ),
                const SizedBox(height: 12),
                Expanded(child: _body(context, state, cubit)),
                ActivityLegendBar(kinds: cubit.legend),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    ActivitiesState state,
    ActivitiesCubit cubit,
  ) {
    if (state is ActivitiesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final activities = cubit.selectedDay?.activities ?? const <ActivityModel>[];

    return BuildCondition(
      condition: activities.isNotEmpty,
      builder: (_) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        children: [
          for (var i = 0; i < activities.length; i++)
            JourneyTimelineTile(
              icon: activities[i].kind.icon,
              dotColor: activities[i].kind.surface,
              iconColor: activities[i].kind.color,
              isLast: i == activities.length - 1,
              child: ActivityCard(activity: activities[i]),
            ),
        ],
      ),
      fallback: (_) => EmptyState(
        message: state is ActivitiesError
            ? state.message.tr()
            : 'no_activities'.tr(),
        onRetry: cubit.getActivities,
      ),
    );
  }
}
