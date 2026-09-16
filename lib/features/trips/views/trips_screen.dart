import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/views/package_details_screen.dart';
import 'package:skygate/features/trips/controller/cubit/trips_cubit.dart';
import 'package:skygate/features/trips/widgets/trip_card.dart';
import 'package:skygate/features/trips/widgets/trips_tab_bar.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key, this.showBack = false, this.onMenuTap});
  final bool showBack;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripsCubit()..getTrips(),
      child: _TripsBody(showBack: showBack, onMenuTap: onMenuTap),
    );
  }
}

class _TripsBody extends StatefulWidget {
  const _TripsBody({required this.showBack, this.onMenuTap});

  final bool showBack;
  final VoidCallback? onMenuTap;

  @override
  State<_TripsBody> createState() => _TripsBodyState();
}

class _TripsBodyState extends State<_TripsBody> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<TripsCubit>().loadMore();
    }
  }

  void _openTrip(BuildContext context, TripModel trip) {
    final tripId = trip.id;
    if (tripId == null) {
      showToast(context, 'no_trip_details'.tr(), isError: true);
      return;
    }
    NaivgatorHelper.pushNavigation(
      context,
      PackageDetailsScreen.booked(tripId: tripId, bookingId: trip.booking?.id),
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
                  padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 16.s),
                  child: AppTitleHeader(
                    title: 'nav_trips'.tr(),
                    showBack: widget.showBack,
                    onMenuTap: widget.onMenuTap,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 16.s),
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
    if (state is TripsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.trips.isNotEmpty,
      builder: (_) => RefreshIndicator(
        onRefresh: () => cubit.getTrips(refresh: true),
        child: ListView.separated(
          controller: _controller,
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 100.s),
          itemCount: cubit.trips.length + (cubit.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => SizedBox(height: 12.s),
          itemBuilder: (_, index) {
            if (index >= cubit.trips.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.s),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final trip = cubit.trips[index];
            return TripCard(
              trip: trip,
              tab: cubit.tab,
              onDetails: () => _openTrip(context, trip),
            );
          },
        ),
      ),
      fallback: (_) => EmptyState(
        message: state is TripsError
            ? state.message.tr()
            : cubit.tab.emptyKey.tr(),
        onRetry: () => cubit.getTrips(refresh: true),
      ),
    );
  }
}
