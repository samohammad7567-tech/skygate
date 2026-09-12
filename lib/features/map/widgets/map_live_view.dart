import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/activity_legend_bar.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/map/controller/cubit/map_cubit.dart';
import 'package:skygate/features/map/widgets/map_activity_row.dart';
import 'package:skygate/features/map/widgets/map_canvas.dart';
import 'package:skygate/features/map/widgets/map_date_bar.dart';

class MapLiveView extends StatelessWidget {
  const MapLiveView({super.key, required this.onPickDate});
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        final cubit = context.read<MapCubit>();

        return Column(
          children: [
            MapDateBar(
              date: cubit.selectedDate,
              onPrevious: () => cubit.stepDay(-1),
              onNext: () => cubit.stepDay(1),
              onPickDate: onPickDate,
            ),
            SizedBox(
              height: 260.vs,
              child: MapCanvas(
                position: cubit.currentPoint,
                activities: cubit.pinnedActivities,
                geofences: cubit.geofences,
                avatarUrl: cubit.user?.avatar,
                focused: cubit.focusedActivity,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => cubit.load(refresh: true),
                child: BuildCondition(
                  condition: cubit.activities.isNotEmpty,
                  builder: (_) => ListView.separated(
                    padding: EdgeInsets.only(bottom: 8.s),
                    itemCount: cubit.activities.length + 1,
                    separatorBuilder: (_, index) =>
                        index == 0 ? const SizedBox.shrink() : const Divider(),
                    itemBuilder: (_, index) => index == 0
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.s,
                              14.s,
                              20.s,
                              10.s,
                            ),
                            child: Text(
                              'map_today_activities'.tr(),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge,
                            ),
                          )
                        : MapActivityRow(
                            activity: cubit.activities[index - 1],
                            onTap: () => cubit.focusActivity(
                              cubit.activities[index - 1],
                            ),
                          ),
                  ),
                  // A scrollable fallback so pull-to-refresh still works on a
                  // day with nothing scheduled.
                  fallback: (_) => ListView(
                    padding: EdgeInsets.only(top: 60.s),
                    children: [
                      EmptyState(
                        message:
                            cubit.errorMessage?.tr() ?? 'no_activities'.tr(),
                        onRetry: () => cubit.load(refresh: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ActivityLegendBar(kinds: cubit.legend),
            // The shell draws its floating navigation bar over this screen, so
            // the legend has to end above it rather than under it.
            SizedBox(height: 88.s),
          ],
        );
      },
    );
  }
}
