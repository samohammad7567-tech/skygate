import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/group_booking/widgets/group_room_counter_sheet.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_hotel_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_rooms_empty_art.dart';
import 'package:skygate/features/vip_trip/widgets/vip_rooms_summary_card.dart';

class VipRoomsScreen extends StatefulWidget {
  const VipRoomsScreen({super.key});

  @override
  State<VipRoomsScreen> createState() => _VipRoomsScreenState();
}

class _VipRoomsScreenState extends State<VipRoomsScreen> {
  Future<void> _editCounts() async {
    final cubit = context.read<VipTripCubit>();
    final counts = await showGroupRoomCounterSheet(
      context,
      types: cubit.offeredRoomTypes,
      initial: cubit.roomCounts,
    );
    if (counts != null) cubit.setRoomCounts(counts);
  }

  void _continue() {
    final cubit = context.read<VipTripCubit>();
    cubit.goToStep(4);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: const VipHotelScreen(city: BookingCity.makkah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VipTripCubit, VipTripState>(
      builder: (context, state) {
        final cubit = context.read<VipTripCubit>();

        return BookingStepScaffold(
          step: 3,
          total: VipTripCubit.totalSteps,
          titleKey: 'private_trip_request_title',
          drawer: const AppDrawer(),
          onContinue: cubit.hasRooms ? _continue : null,
          children: [
            BookingSectionTitle(
              title: 'select_rooms_title'.tr(),
              subtitle: 'applies_to_both_cities'.tr(),
            ),
            Gap(16.s),
            if (cubit.hasRooms)
              AppOutlinedButton(
                label: 'edit_rooms_action'.tr(),
                onPressed: _editCounts,
              )
            else
              CustomButton(
                label: 'select_rooms_action'.tr(),
                height: 48.s,
                width: double.infinity,
                onPressed: _editCounts,
              ),
            Gap(20.s),
            if (cubit.hasRooms)
              VipRoomsSummaryCard(counts: cubit.roomCounts)
            else
              Padding(
                padding: EdgeInsets.only(top: 40.s),
                child: VipRoomsEmptyArt(),
              ),
          ],
        );
      },
    );
  }
}
