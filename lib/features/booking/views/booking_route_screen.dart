import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_room_type_screen.dart';
import 'package:skygate/core/components/booking_route_card.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';

/// Step 3 — "اختر المسار".
class BookingRouteScreen extends StatefulWidget {
  const BookingRouteScreen({super.key});

  @override
  State<BookingRouteScreen> createState() => _BookingRouteScreenState();
}

class _BookingRouteScreenState extends State<BookingRouteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getRoutes();
  }

  void _continue() {
    final cubit = context.read<BookingCubit>();
    cubit.goToStep(4);
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const BookingRoomTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return BookingStepScaffold(
          step: 3,
          onContinue: cubit.selectedRoute == null ? null : _continue,
          children: [
            BookingSectionTitle(
              title: 'select_route'.tr(),
              subtitle: 'select_route_desc'.tr(),
            ),
            const Gap(16),
            if (state is BookingRoutesLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BuildCondition(
                condition: cubit.routes.isNotEmpty,
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cubit.routes.length; i++) ...[
                      BookingRouteCard(
                        route: cubit.routes[i],
                        position: i + 1,
                        isSelected: i == cubit.selectedRouteIndex,
                        onTap: () => cubit.selectRoute(i),
                      ),
                      const Gap(16),
                    ],
                  ],
                ),
                fallback: (_) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: EmptyState(
                    message: state is BookingRoutesError
                        ? state.message.tr()
                        : 'no_routes'.tr(),
                    onRetry: cubit.getRoutes,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
