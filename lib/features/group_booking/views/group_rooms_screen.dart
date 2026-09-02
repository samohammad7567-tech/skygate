import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_hotel_screen.dart';
import 'package:skygate/features/group_booking/widgets/group_dialogs.dart';
import 'package:skygate/features/group_booking/widgets/group_room_card.dart';
import 'package:skygate/features/group_booking/widgets/group_room_counter_sheet.dart';
import 'package:skygate/features/group_booking/widgets/group_traveler_picker_sheet.dart';

/// Step 7 — "اختر عدد الغرف و أنواعها": how many rooms of each size the group
/// takes, and who sleeps in each of them.
class GroupRoomsScreen extends StatefulWidget {
  const GroupRoomsScreen({super.key});

  @override
  State<GroupRoomsScreen> createState() => _GroupRoomsScreenState();
}

class _GroupRoomsScreenState extends State<GroupRoomsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBookingCubit>().getRoomPrices();
  }

  Future<void> _editCounts() async {
    final cubit = context.read<GroupBookingCubit>();
    final counts = await showGroupRoomCounterSheet(
      context,
      types: cubit.offeredRoomTypes,
      initial: cubit.roomCounts,
    );
    if (counts != null) cubit.setRoomCounts(counts);
  }

  /// Seats travellers, then offers to pay for whatever beds are left empty so
  /// the room can still be booked.
  Future<void> _assign(int index) async {
    final cubit = context.read<GroupBookingCubit>();
    final room = cubit.rooms[index];

    final picked = await showGroupTravelerPickerSheet(
      context,
      type: room.type,
      travelers: cubit.travelersFor(index),
      selected: room.travelerIds,
      capacity: room.capacity,
      currency: room.currency,
      priceOf: (selection, id) => cubit.priceIn(room.type, selection, id),
      isSecondInfant: cubit.isSecondInfant,
    );
    if (picked == null) return;
    cubit.assignTravelers(index, picked);

    if (!mounted || room.freeBeds == 0 || room.isEmpty) return;
    if (await showGroupLockBedsDialog(context)) cubit.lockSpareBeds(index);
  }

  Future<void> _delete(int index) async {
    final cubit = context.read<GroupBookingCubit>();
    if (await showGroupDeleteRoomDialog(context)) cubit.removeRoom(index);
  }

  void _continue() {
    final cubit = context.read<GroupBookingCubit>();
    if (!cubit.areRoomsSettled) {
      showToast(context, 'assign_all_travelers'.tr(), isError: true);
      return;
    }
    cubit.goToStep(8);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        // Step 8 walks the cities in order, Makkah first.
        child: const GroupHotelScreen(city: BookingCity.makkah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBookingCubit, GroupBookingState>(
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();

        return BookingStepScaffold(
          step: 7,
          total: GroupBookingCubit.totalSteps,
          onContinue: cubit.rooms.isEmpty ? null : _continue,
          children: [
            BookingSectionTitle(
              title: 'select_rooms_title'.tr(),
              subtitle: 'select_rooms_desc'.tr(),
            ),
            const Gap(16),
            if (cubit.rooms.isEmpty)
              CustomButton(
                label: 'select_rooms_action'.tr(),
                height: 48,
                width: double.infinity,
                onPressed: _editCounts,
              )
            else
              AppOutlinedButton(
                label: 'edit_rooms_action'.tr(),
                onPressed: _editCounts,
              ),
            const Gap(18),
            if (state is GroupRoomPricesLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BuildCondition(
                condition: cubit.rooms.isNotEmpty,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cubit.rooms.length; i++) ...[
                      GroupRoomCard(
                        room: cubit.rooms[i],
                        seats: cubit.seatsOf(cubit.rooms[i]),
                        total: cubit.totalOf(cubit.rooms[i]),
                        onAssign: () => _assign(i),
                        onDelete: () => _delete(i),
                      ),
                      const Gap(16),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: EmptyState(
                    message: state is GroupRoomPricesError
                        ? state.message.tr()
                        : 'no_rooms'.tr(),
                    onRetry: state is GroupRoomPricesError
                        ? cubit.getRoomPrices
                        : null,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
