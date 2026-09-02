import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/features/booking/views/booking_hotel_screen.dart';
import 'package:skygate/features/booking/widgets/booking_room_card.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';

/// Step 4 — "اختر نوع الغرفة". The choice applies to both cities.
class BookingRoomTypeScreen extends StatefulWidget {
  const BookingRoomTypeScreen({super.key});

  @override
  State<BookingRoomTypeScreen> createState() => _BookingRoomTypeScreenState();
}

class _BookingRoomTypeScreenState extends State<BookingRoomTypeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getRoomTypes();
  }

  void _continue() {
    final cubit = context.read<BookingCubit>();
    cubit.goToStep(5);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        // Step 5 walks the cities in order, Makkah first.
        child: const BookingHotelScreen(city: BookingCity.makkah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return BookingStepScaffold(
          step: 4,
          onContinue: cubit.selectedRoom == null ? null : _continue,
          children: [
            BookingSectionTitle(
              title: 'select_room_type'.tr(),
              subtitle: 'select_room_type_desc'.tr(),
            ),
            const Gap(16),
            if (state is RoomTypesLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BuildCondition(
                condition: cubit.roomTypes.isNotEmpty,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cubit.roomTypes.length; i++) ...[
                      BookingRoomCard(
                        room: cubit.roomTypes[i],
                        isSelected: i == cubit.selectedRoomIndex,
                        onTap: () => cubit.selectRoom(i),
                      ),
                      const Gap(16),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: EmptyState(
                    message: state is RoomTypesError
                        ? state.message.tr()
                        : 'no_room_types'.tr(),
                    onRetry: cubit.getRoomTypes,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
