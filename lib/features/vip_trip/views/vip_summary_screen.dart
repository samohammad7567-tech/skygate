import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/booking_bottom_bar.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/utils/vip_travelers_label.dart';
import 'package:skygate/features/vip_trip/views/vip_success_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_summary_card.dart';

class VipSummaryScreen extends StatelessWidget {
  const VipSummaryScreen({super.key});

  void _onState(BuildContext context, VipTripState state) {
    if (state is VipSubmitted) {
      NaivgatorHelper.pushNavigation(context, const VipSuccessScreen());
    } else if (state is VipSubmitError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<VipTripCubit, VipTripState>(
          listener: _onState,
          builder: (context, state) {
            final cubit = context.read<VipTripCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'private_trip_request_details'.tr()),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    children: [
                      VipSummaryCard(
                        travelers: vipTravelersLabel(cubit.counts),
                        startDate: cubit.startDate,
                        endDate: cubit.endDate,
                        makkahNights: cubit.nightsIn(BookingCity.makkah),
                        madinahNights: cubit.nightsIn(BookingCity.madinah),
                        roomCounts: cubit.roomCounts,
                        makkahHotel: cubit
                            .selectedHotelIn(BookingCity.makkah)
                            ?.name,
                        madinahHotel: cubit
                            .selectedHotelIn(BookingCity.madinah)
                            ?.name,
                        notes: cubit.requirementsController.text.trim(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<VipTripCubit, VipTripState>(
        builder: (context, state) => BookingBottomBar(
          isLoading: state is VipSubmitLoading,
          onContinue: context.read<VipTripCubit>().submit,
        ),
      ),
    );
  }
}
