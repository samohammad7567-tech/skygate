import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_date_field.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/core/components/labeled_field.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_rooms_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_card.dart';
import 'package:skygate/features/vip_trip/widgets/vip_stepper_row.dart';

class VipDurationScreen extends StatelessWidget {
  const VipDurationScreen({super.key});

  void _continue(BuildContext context) {
    final cubit = context.read<VipTripCubit>();
    cubit.goToStep(3);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const VipRoomsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VipTripCubit, VipTripState>(
      builder: (context, state) {
        final cubit = context.read<VipTripCubit>();
        final start = cubit.startDate;

        return BookingStepScaffold(
          step: 2,
          total: VipTripCubit.totalSteps,
          titleKey: 'private_trip_request_title',
          drawer: const AppDrawer(),
          onContinue: cubit.hasDuration ? () => _continue(context) : null,
          children: [
            BookingSectionTitle(
              title: 'select_trip_duration'.tr(),
              subtitle: 'select_trip_duration_desc'.tr(),
            ),
            Gap(14.s),
            VipCard(
              totalLabelKey: 'total_trip_duration',
              totalValue: 'days_count'.tr(
                namedArgs: {'count': '${cubit.totalNights}'},
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(14.s, 14.s, 14.s, 14.s),
                  child: Column(
                    children: [
                      LabeledField(
                        label: 'start_date'.tr(),
                        child: AppDateField(
                          hint: 'start_date'.tr(),
                          value: start,
                          // `preferred_start_date` must be after today.
                          firstDate: cubit.firstSelectableDate,
                          onPicked: cubit.setStartDate,
                        ),
                      ),
                      Gap(14.s),
                      LabeledField(
                        label: 'end_date'.tr(),
                        child: AppDateField(
                          hint: 'end_date'.tr(),
                          value: cubit.endDate,
                          // …and the end must be after the start.
                          firstDate:
                              start?.add(const Duration(days: 1)) ??
                              cubit.firstSelectableDate,
                          onPicked: cubit.setEndDate,
                        ),
                      ),
                    ],
                  ),
                ),
                for (final city in BookingCity.values)
                  VipStepperRow(
                    label: city.nightsLabelKey.tr(),
                    value: cubit.nightsIn(city),
                    onChanged: (value) => cubit.setNights(city, value),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
