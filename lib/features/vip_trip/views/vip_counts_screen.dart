import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_duration_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_card.dart';
import 'package:skygate/features/vip_trip/widgets/vip_stepper_row.dart';

class VipCountsScreen extends StatelessWidget {
  const VipCountsScreen({super.key});
  static const Map<TravelerAudience, String> _icons = {
    TravelerAudience.adult: VipTripAssets.adult,
    TravelerAudience.child: VipTripAssets.child,
    TravelerAudience.infant: VipTripAssets.infant,
  };

  void _continue(BuildContext context) {
    final cubit = context.read<VipTripCubit>();
    cubit.goToStep(2);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const VipDurationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VipTripCubit, VipTripState>(
      builder: (context, state) {
        final cubit = context.read<VipTripCubit>();

        return BookingStepScaffold(
          step: 1,
          total: VipTripCubit.totalSteps,
          titleKey: 'private_trip_request_title',
          drawer: const AppDrawer(),
          onContinue: cubit.hasTravelers ? () => _continue(context) : null,
          children: [
            BookingSectionTitle(title: 'select_people_count'.tr()),
            Gap(14.s),
            VipCard(
              totalLabelKey: 'total_travelers_count',
              totalValue: 'travelers_count'.tr(
                namedArgs: {'count': '${cubit.totalTravelers}'},
              ),
              children: [
                for (final audience in TravelerAudience.values)
                  VipStepperRow(
                    label: audience.labelKey.tr(),
                    icon: _icons[audience],
                    value: cubit.countOf(audience),
                    max: VipTripCubit.maxPerAudience,
                    min: audience == TravelerAudience.adult ? 1 : 0,
                    onChanged: (value) => cubit.setCount(audience, value),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
