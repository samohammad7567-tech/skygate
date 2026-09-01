import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/widgets/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/models/traveler_audience.dart';
import 'package:skygate/features/group_booking/views/group_route_screen.dart';
import 'package:skygate/features/group_booking/views/group_verify_screen.dart';
import 'package:skygate/features/group_booking/widgets/group_add_traveler_button.dart';
import 'package:skygate/features/group_booking/widgets/group_counts_card.dart';
import 'package:skygate/features/group_booking/widgets/group_traveler_card.dart';

/// Steps 3 and 5 — "تكوين المجموعة".
///
/// The same card serves both: it is step 3 while the group is still only its
/// leader, and step 5 once travellers have been added to it.
class GroupCompositionScreen extends StatelessWidget {
  const GroupCompositionScreen({super.key});

  /// Anchor the add-traveller detour unwinds back to.
  static const String routeName = 'group-composition';

  void _addTraveler(BuildContext context) {
    final cubit = context.read<GroupBookingCubit>();
    cubit.startNewTraveler();
    cubit.goToStep(4);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const GroupVerifyScreen()),
    );
  }

  void _continue(BuildContext context) {
    final cubit = context.read<GroupBookingCubit>();
    if (!cubit.isGroupComplete) {
      showToast(context, 'must_add_two_travelers'.tr(), isError: true);
      return;
    }
    cubit.goToStep(6);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const GroupRouteScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBookingCubit, GroupBookingState>(
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();
        final isComplete = cubit.isGroupComplete;

        return BookingStepScaffold(
          step: isComplete ? 5 : 3,
          total: GroupBookingCubit.totalSteps,
          onContinue: isComplete ? () => _continue(context) : null,
          children: [
            BookingSectionTitle(
              title: 'group_composition'.tr(),
              subtitle: 'group_composition_desc'.tr(),
            ),
            const Gap(16),
            GroupCountsCard(
              counts: {
                for (final audience in TravelerAudience.values)
                  audience: cubit.countOf(audience),
              },
            ),
            const Gap(18),
            Center(
              child: GroupAddTravelerButton(
                onTap: () => _addTraveler(context),
                filled: !isComplete,
              ),
            ),
            const Gap(18),
            BuildCondition(
              condition: cubit.travelers.isNotEmpty,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cubit.travelers.length; i++) ...[
                    GroupTravelerCard(
                      traveler: cubit.travelers[i],
                      position: i + 1,
                      guardianName: cubit
                          .travelerOf(cubit.travelers[i].guardianLocalId)
                          ?.name,
                    ),
                    const Gap(16),
                  ],
                ],
              ),
              fallback: (_) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: EmptyState(message: 'no_travelers'.tr()),
              ),
            ),
          ],
        );
      },
    );
  }
}
