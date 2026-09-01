import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/models/booking_city.dart';
import 'package:skygate/features/booking/views/booking_summary_screen.dart';
import 'package:skygate/features/booking/widgets/booking_hotel_card.dart';
import 'package:skygate/features/booking/widgets/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_stay_row.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';

/// Step 5 — "اختر فندق مكة المكرمة", then the same screen again for
/// "المدينة المنورة". The last city hands over to the summary.
class BookingHotelScreen extends StatefulWidget {
  const BookingHotelScreen({super.key, required this.city});

  final BookingCity city;

  @override
  State<BookingHotelScreen> createState() => _BookingHotelScreenState();
}

class _BookingHotelScreenState extends State<BookingHotelScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getHotels(widget.city);
  }

  void _continue() {
    final cubit = context.read<BookingCubit>();
    final next = widget.city.next;

    if (next != null) {
      NaivgatorHelper.pushNavigation(
        context,
        BlocProvider.value(
          value: cubit,
          child: BookingHotelScreen(city: next),
        ),
      );
      return;
    }

    cubit.goToStep(6);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const BookingSummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final hotels = cubit.hotelsIn(widget.city);

        return BookingStepScaffold(
          step: 5,
          onContinue: cubit.selectedHotelIn(widget.city) == null
              ? null
              : _continue,
          children: [
            BookingSectionTitle(
              title: 'select_hotel_in'.tr(args: [widget.city.labelKey.tr()]),
            ),
            const Gap(10),
            BookingStayRow(
              city: widget.city,
              days: cubit.stayDays[widget.city],
            ),
            const Gap(16),
            if (state is BookingHotelsLoading)
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
                    for (var i = 0; i < hotels.length; i++) ...[
                      BookingHotelCard(
                        hotel: hotels[i],
                        isSelected:
                            i == cubit.selectedHotelIndexIn(widget.city),
                        onTap: () => cubit.selectHotel(widget.city, i),
                      ),
                      const Gap(14),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: EmptyState(
                    message: state is BookingHotelsError
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
