import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/components/booking_route_card.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_rooms_screen.dart';

/// Step 6 — "اختر المسار". The whole group travels the same route.
class GroupRouteScreen extends StatefulWidget {
  const GroupRouteScreen({super.key});

  @override
  State<GroupRouteScreen> createState() => _GroupRouteScreenState();
}

class _GroupRouteScreenState extends State<GroupRouteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBookingCubit>().getRoutes();
  }

  void _continue() {
    final cubit = context.read<GroupBookingCubit>();
    cubit.goToStep(7);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const GroupRoomsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBookingCubit, GroupBookingState>(
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();

        return BookingStepScaffold(
          step: 6,
          total: GroupBookingCubit.totalSteps,
          onContinue: cubit.selectedRoute == null ? null : _continue,
          children: [
            BookingSectionTitle(
              title: 'select_route'.tr(),
              subtitle: 'select_route_desc'.tr(),
            ),
            const Gap(16),
            if (state is GroupRoutesLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BuildCondition(
                condition: cubit.routes.isNotEmpty,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cubit.routes.length; i++) ...[
                      BookingRouteCard(
                        route: cubit.routes[i],
                        position: i + 1,
                        isSelected: i == cubit.selectedRouteIndex,
                        onTap: () => cubit.selectRoute(i),
                      ),
                      const Gap(16),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: EmptyState(
                    message: state is GroupRoutesError
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
