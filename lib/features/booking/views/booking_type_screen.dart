import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_verify_screen.dart';
import 'package:skygate/features/booking/widgets/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/booking/widgets/booking_type_card.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_verify_screen.dart';

/// Step 1 — "نوع الحجز". Entry point of both booking wizards: "حجز فردي فقط"
/// carries on through the six individual steps, while "حجز مجموعة /عائلة"
/// hands over to the nine-step group wizard and its own cubit.
class BookingTypeScreen extends StatelessWidget {
  const BookingTypeScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(tripId),
      child: const _BookingTypeBody(),
    );
  }
}

class _BookingTypeBody extends StatelessWidget {
  const _BookingTypeBody();

  void _continue(BuildContext context) {
    final cubit = context.read<BookingCubit>();

    if (cubit.selectedType == BookingType.group) {
      _startGroupBooking(context, cubit.tripId);
      return;
    }

    cubit.goToStep(2);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const BookingVerifyScreen()),
    );
  }

  /// Opens the group wizard on its own cubit, which owns everything from the
  /// first traveller through to the booking it creates.
  void _startGroupBooking(BuildContext context, int tripId) {
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider(
        create: (_) => GroupBookingCubit(tripId)..goToStep(2),
        child: const GroupVerifyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return BookingStepScaffold(
          step: 1,
          // The group flow is three steps longer, and the design already
          // prints its total on this card.
          total: cubit.selectedType == BookingType.group
              ? GroupBookingCubit.totalSteps
              : BookingCubit.totalSteps,
          onContinue: () => _continue(context),
          children: [
            BookingSectionTitle(
              title: 'booking_type'.tr(),
              subtitle: 'booking_type_question'.tr(),
            ),
            const Gap(16),
            for (final option in cubit.options) ...[
              BookingTypeCard(
                option: option,
                isSelected: option.type == cubit.selectedType,
                onTap: () => cubit.selectType(option.type),
              ),
              const Gap(16),
            ],
          ],
        );
      },
    );
  }
}
