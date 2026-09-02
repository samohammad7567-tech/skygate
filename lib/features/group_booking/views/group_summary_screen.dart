import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/models/group_room_model.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/features/group_booking/views/group_confirmation_screen.dart';
import 'package:skygate/features/group_booking/widgets/group_countdown_card.dart';
import 'package:skygate/features/group_booking/widgets/group_summary_card.dart';
import 'package:skygate/features/group_booking/widgets/group_summary_room_card.dart';
import 'package:skygate/features/group_booking/widgets/group_travelers_sheet.dart';

/// Step 9 — "ملخص الحجز": the hold countdown and the priced review, then the
/// button that creates the booking.
class GroupSummaryScreen extends StatefulWidget {
  const GroupSummaryScreen({super.key});

  @override
  State<GroupSummaryScreen> createState() => _GroupSummaryScreenState();
}

class _GroupSummaryScreenState extends State<GroupSummaryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBookingCubit>().prepareSummary();
  }

  void _showTravelers(GroupRoomModel room) {
    final cubit = context.read<GroupBookingCubit>();
    showGroupTravelersSheet(
      context,
      seats: cubit.seatsOf(room),
      currency: room.currency,
    );
  }

  void _onState(BuildContext context, GroupBookingState state) {
    if (state is GroupSubmitted) {
      NaivgatorHelper.pushNavigation(context, const GroupConfirmationScreen());
    } else if (state is GroupSubmitError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBookingCubit, GroupBookingState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<GroupBookingCubit>();

        return BookingStepScaffold(
          step: 9,
          total: GroupBookingCubit.totalSteps,
          isLoading: state is GroupSubmitLoading,
          onContinue: cubit.rooms.isEmpty ? null : cubit.submit,
          children: [
            BookingSectionTitle(
              title: 'booking_summary'.tr(),
              subtitle: 'review_your_booking'.tr(),
            ),
            const Gap(16),
            GroupCountdownCard(
              remaining: cubit.remaining,
              deadline: cubit.paymentDeadline,
            ),
            const Gap(16),
            GroupSummaryCard(
              tripTitle: cubit.tripTitle,
              routeName: cubit.selectedRoute?.name,
              counts: {
                for (final audience in TravelerAudience.values)
                  audience: cubit.countOf(audience),
              },
              grandTotal: cubit.grandTotal,
              currency: cubit.currency,
              rooms: _rooms(cubit),
            ),
          ],
        );
      },
    );
  }

  /// One block per room, each carrying the hotel it takes in either city.
  List<Widget> _rooms(GroupBookingCubit cubit) => [
    for (var i = 0; i < cubit.rooms.length; i++)
      GroupSummaryRoomCard(
        room: cubit.rooms[i],
        counts: cubit.countsIn(cubit.rooms[i]),
        hotelNames: {
          for (final city in BookingCity.values)
            city: cubit.hotelFor(city, i)?.name,
        },
        total: cubit.totalOf(cubit.rooms[i]),
        currency: cubit.rooms[i].currency,
        onDetails: () => _showTravelers(cubit.rooms[i]),
      ),
  ];
}
