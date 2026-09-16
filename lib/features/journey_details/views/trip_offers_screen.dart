import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/controller/cubit/trip_offers_cubit.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/trip_offer_card.dart';

class TripOffersScreen extends StatelessWidget {
  const TripOffersScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripOffersCubit(tripId)..getOffers(),
      child: const _TripOffersBody(),
    );
  }
}

class _TripOffersBody extends StatelessWidget {
  const _TripOffersBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TripOffersCubit, TripOffersState>(
          builder: (context, state) {
            final cubit = context.read<TripOffersCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'trip_offers'.tr()),
                Expanded(child: _body(context, state, cubit)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: JourneyBottomBar(
        label: 'continue_booking_payment'.tr(),
        onPressed: () {},
      ),
    );
  }

  Widget _body(
    BuildContext context,
    TripOffersState state,
    TripOffersCubit cubit,
  ) {
    if (state is TripOffersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.offers.isNotEmpty,
      builder: (_) => ListView.separated(
        padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 20.s),
        itemCount: cubit.offers.length,
        separatorBuilder: (_, _) => SizedBox(height: 14.s),
        itemBuilder: (_, index) => TripOfferCard(
          offer: cubit.offers[index],
          position: index + 1,
          selectedType: cubit.selectedBookingTypeAt(index),
          onTypeSelected: (type) => cubit.selectBookingType(index, type),
        ),
      ),
      fallback: (_) => EmptyState(
        message: state is TripOffersError
            ? state.message.tr()
            : 'no_trip_offers'.tr(),
        onRetry: () => cubit.getOffers(refresh: true),
      ),
    );
  }
}
