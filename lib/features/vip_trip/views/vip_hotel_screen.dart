import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_requirements_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_hotel_option_card.dart';

class VipHotelScreen extends StatefulWidget {
  const VipHotelScreen({super.key, required this.city});

  final BookingCity city;

  @override
  State<VipHotelScreen> createState() => _VipHotelScreenState();
}

class _VipHotelScreenState extends State<VipHotelScreen> {
  int get _step => 4 + BookingCity.values.indexOf(widget.city);

  @override
  void initState() {
    super.initState();
    context.read<VipTripCubit>().getHotels(widget.city);
  }

  void _continue() {
    final cubit = context.read<VipTripCubit>();
    final next = widget.city.next;

    cubit.goToStep(_step + 1);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: next != null
            ? VipHotelScreen(city: next)
            : const VipRequirementsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VipTripCubit, VipTripState>(
      builder: (context, state) {
        final cubit = context.read<VipTripCubit>();
        final hotels = cubit.hotelsIn(widget.city);
        final selected = cubit.selectedHotelIn(widget.city);

        return BookingStepScaffold(
          step: _step,
          total: VipTripCubit.totalSteps,
          titleKey: 'private_trip_request_title',
          drawer: const AppDrawer(),
          onContinue: selected == null ? null : _continue,
          children: [
            BookingSectionTitle(
              title: 'select_hotel_in'.tr(args: [widget.city.labelKey.tr()]),
            ),
            Gap(16.s),
            if (state is VipHotelsLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60.s),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.s),
                ),
              )
            else
              BuildCondition(
                condition: hotels.isNotEmpty,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final hotel in hotels) ...[
                      VipHotelOptionCard(
                        hotel: hotel,
                        isSelected: selected?.id == hotel.id,
                        onTap: () => cubit.selectHotel(widget.city, hotel),
                      ),
                      Gap(14.s),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 60.s),
                  child: EmptyState(
                    message: state is VipHotelsError
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
