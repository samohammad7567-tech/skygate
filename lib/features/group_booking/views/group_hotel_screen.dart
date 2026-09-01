import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/models/booking_city.dart';
import 'package:skygate/features/booking/widgets/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_stay_row.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_summary_screen.dart';
import 'package:skygate/features/group_booking/widgets/group_allocation_progress_card.dart';
import 'package:skygate/features/group_booking/widgets/group_hotel_card.dart';
import 'package:skygate/features/group_booking/widgets/group_room_counter_sheet.dart';

/// Step 8 — "اختر فندق مكة المكرمة", then the same screen for
/// "المدينة المنورة": the group's rooms are spread over the city's hotels
/// until every one of them has a bed. The last city hands over to the summary.
class GroupHotelScreen extends StatefulWidget {
  const GroupHotelScreen({super.key, required this.city});

  final BookingCity city;

  @override
  State<GroupHotelScreen> createState() => _GroupHotelScreenState();
}

class _GroupHotelScreenState extends State<GroupHotelScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBookingCubit>().getHotels(widget.city);
  }

  /// Hands one hotel a share of the group's rooms, capped by what the other
  /// hotels in the city have left over.
  Future<void> _allocate(HotelModel hotel) async {
    final cubit = context.read<GroupBookingCubit>();
    final hotelId = hotel.id;
    if (hotelId == null) return;

    final counts = await showGroupRoomCounterSheet(
      context,
      types: cubit.roomCounts.keys.toList(),
      initial: cubit.allocationOf(widget.city, hotelId).counts,
      maxCounts: cubit.availableIn(widget.city, hotelId),
    );
    if (counts != null) cubit.allocateRooms(widget.city, hotelId, counts);
  }

  void _continue() {
    final cubit = context.read<GroupBookingCubit>();
    if (!cubit.isCityAllocated(widget.city)) {
      showToast(context, 'assign_all_rooms'.tr(), isError: true);
      return;
    }

    final next = widget.city.next;
    if (next != null) {
      NaivgatorHelper.pushNavigation(
        context,
        BlocProvider.value(
          value: cubit,
          child: GroupHotelScreen(city: next),
        ),
      );
      return;
    }

    cubit.goToStep(9);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const GroupSummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBookingCubit, GroupBookingState>(
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();
        final hotels = cubit.hotelsIn(widget.city);

        return BookingStepScaffold(
          step: 8,
          total: GroupBookingCubit.totalSteps,
          onContinue: _continue,
          children: [
            BookingSectionTitle(
              title: 'select_hotel_in'.tr(args: [widget.city.labelKey.tr()]),
              subtitle: 'select_hotel_desc'.tr(),
            ),
            const Gap(16),
            GroupAllocationProgressCard(
              allocated: cubit.allocatedIn(widget.city),
              total: cubit.rooms.length,
            ),
            const Gap(16),
            BookingStayRow(
              city: widget.city,
              days: cubit.stayDays[widget.city],
            ),
            const Gap(16),
            if (state is GroupHotelsLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BuildCondition(
                condition: hotels.isNotEmpty,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final hotel in hotels) ...[
                      GroupHotelCard(
                        hotel: hotel,
                        allocation: cubit.allocationOf(widget.city, hotel.id),
                        onAllocate: () => _allocate(hotel),
                      ),
                      const Gap(14),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: EmptyState(
                    message: state is GroupHotelsError
                        ? state.message.tr()
                        : 'no_hotels'.tr(),
                    onRetry: () => cubit.getHotels(widget.city),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
