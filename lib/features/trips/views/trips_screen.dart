import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/views/package_details_screen.dart';
import 'package:skygate/features/payments/views/payments_screen.dart';
import 'package:skygate/features/trips/controller/cubit/trips_cubit.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';
import 'package:skygate/features/trips/widgets/trip_booking_card.dart';
import 'package:skygate/features/trips/widgets/trips_tab_bar.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key, this.showBack = false, this.onMenuTap});
  final bool showBack;

  /// Opens the shell's drawer. The shell owns the panel, so a tab only
  /// forwards the tap.
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripsCubit()..getBookings(),
      child: _TripsBody(showBack: showBack, onMenuTap: onMenuTap),
    );
  }
}

class _TripsBody extends StatelessWidget {
  const _TripsBody({required this.showBack, this.onMenuTap});

  final bool showBack;
  final VoidCallback? onMenuTap;

  void _openTrip(BuildContext context, BookingTripModel booking) {
    final tripId = booking.tripId;
    if (tripId == null) {
      // `BookingResource` carries no trip, so a booking the API returns bare
      // has nothing to open. Say so rather than pushing an empty screen.
      showToast(context, 'no_trip_details'.tr(), isError: true);
      return;
    }
    NaivgatorHelper.pushNavigation(
      context,
      // Handing the booking over is what puts "حجوزاتي و المدفوعات" on the
      // overview and turns its action into "اضافة حجز جديد".
      PackageDetailsScreen(tripId: tripId, bookingId: booking.id),
    );
  }

  void _openPayments(BuildContext context, BookingTripModel booking) {
    final bookingId = booking.id;
    if (bookingId == null) return;
    NaivgatorHelper.pushNavigation(
      context,
      PaymentsScreen(bookingId: bookingId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            final cubit = context.read<TripsCubit>();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: AppTitleHeader(
                    title: 'nav_trips'.tr(),
                    showBack: showBack,
                    onMenuTap: onMenuTap,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: TripsTabBar(
                    selected: cubit.tab,
                    onChanged: cubit.changeTab,
                  ),
                ),
                Expanded(child: _list(context, state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(BuildContext context, TripsState state, TripsCubit cubit) {
    if (state is BookingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.bookings.isNotEmpty,
      builder: (_) => RefreshIndicator(
        onRefresh: cubit.getBookings,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          itemCount: cubit.bookings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final booking = cubit.bookings[index];
            return TripBookingCard(
              booking: booking,
              onDetails: () => _openTrip(context, booking),
              onPay: () => _openPayments(context, booking),
            );
          },
        ),
      ),
      fallback: (_) => EmptyState(
        message: state is BookingsError
            ? state.message.tr()
            : 'no_bookings'.tr(),
        onRetry: cubit.getBookings,
      ),
    );
  }
}
