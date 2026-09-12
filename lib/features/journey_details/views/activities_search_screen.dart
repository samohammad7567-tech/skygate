import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/features/journey_details/controller/cubit/activities_cubit.dart';
import 'package:skygate/features/journey_details/widgets/activity_card.dart';
import 'package:skygate/features/journey_details/widgets/activity_search_bar.dart';

/// "الأنشطة" — the whole programme in one list, searched by name or place and
/// narrowed by kind.
///
/// Reached from the day schedule's "بحث عن أنشطة" and shares its cubit, so a
/// filter set here is still set when the reader goes back to the schedule.
/// The cards list rather than act: no timeline rail, no check-in button.
class ActivitiesSearchScreen extends StatelessWidget {
  const ActivitiesSearchScreen({super.key});

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
                AppPageHeader(title: 'activities'.tr()),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: ActivitySearchBar(),
                ),
                Expanded(child: _body(state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(ActivitiesState state, ActivitiesCubit cubit) {
    if (state is ActivitiesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final results = cubit.searchResults;

    return BuildCondition(
      condition: results.isNotEmpty,
      builder: (_) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: results.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) => ActivityCard(activity: results[index]),
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
