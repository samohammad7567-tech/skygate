import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_summary_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_requirements_field.dart';

class VipRequirementsScreen extends StatelessWidget {
  const VipRequirementsScreen({super.key});

  void _continue(BuildContext context) {
    FocusScope.of(context).unfocus();
    final cubit = context.read<VipTripCubit>();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const VipSummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VipTripCubit, VipTripState>(
      builder: (context, state) {
        final cubit = context.read<VipTripCubit>();

        return BookingStepScaffold(
          step: 6,
          total: VipTripCubit.totalSteps,
          titleKey: 'private_trip_request_title',
          drawer: const AppDrawer(),
          onContinue: () => _continue(context),
          children: [
            BookingSectionTitle(
              title: 'other_requirements'.tr(),
              subtitle: 'other_requirements_desc'.tr(),
            ),
            Gap(14.s),
            VipRequirementsField(
              controller: cubit.requirementsController,
              maxLength: VipTripCubit.maxRequirementsLength,
            ),
          ],
        );
      },
    );
  }
}
