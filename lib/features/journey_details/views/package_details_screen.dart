import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/views/booking_type_screen.dart';
import 'package:skygate/features/cards/views/trip_cards_screen.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';
import 'package:skygate/features/journey_details/views/activities_screen.dart';
import 'package:skygate/features/journey_details/views/hotels_screen.dart';
import 'package:skygate/features/journey_details/views/itinerary_screen.dart';
import 'package:skygate/features/journey_details/views/trip_offers_screen.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/current_trip_card.dart';
import 'package:skygate/features/journey_details/widgets/journey_section_tile.dart';
import 'package:skygate/features/journey_details/widgets/trip_stat_grid.dart';
import 'package:skygate/features/journey_details/widgets/journey_supervisors_card.dart';
import 'package:skygate/features/payments/views/payments_screen.dart';

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key, required this.tripId})
    : bookingId = null,
      canBook = true;

  const PackageDetailsScreen.booked({
    super.key,
    required this.tripId,
    required this.bookingId,
  }) : canBook = false;

  final int tripId;
  final int? bookingId;
  final bool canBook;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JourneyDetailsCubit(tripId)..getPackage(),
      child: _PackageDetailsBody(bookingId: bookingId, canBook: canBook),
    );
  }
}

class _PackageDetailsBody extends StatelessWidget {
  const _PackageDetailsBody({required this.bookingId, required this.canBook});

  final int? bookingId;
  final bool canBook;

  void _startBooking(BuildContext context) {
    NaivgatorHelper.pushNavigation(
      context,
      BookingTypeScreen(tripId: context.read<JourneyDetailsCubit>().tripId),
    );
  }

  void _openSection(BuildContext context, JourneySection section) {
    final tripId = context.read<JourneyDetailsCubit>().tripId;

    NaivgatorHelper.pushNavigation(context, switch (section) {
      JourneySection.routes => ItineraryScreen(
        tripId: tripId,
        bookingId: bookingId,
      ),
      JourneySection.hotels => HotelsScreen(tripId: tripId),
      JourneySection.activities => ActivitiesScreen(tripId: tripId),
      JourneySection.offers => TripOffersScreen(tripId: tripId),
      JourneySection.booking => PaymentsScreen(bookingId: bookingId!),
      JourneySection.cards => TripCardsScreen(bookingId: bookingId!),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 0),
              child: AppTitleHeader(showBack: true),
            ),
            Expanded(child: _content(context)),
          ],
        ),
      ),
      bottomNavigationBar: canBook
          ? JourneyBottomBar(
              label: 'start_booking'.tr(),
              onPressed: () => _startBooking(context),
            )
          : null,
    );
  }

  Widget _content(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
      builder: (context, state) {
        final cubit = context.read<JourneyDetailsCubit>();
        final package = cubit.package;

        if (state is PackageLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final sections = canBook
            ? JourneySectionModel.catalogue
            : JourneySectionModel.bookedCatalogue;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 0),
              child: CurrentTripCard(package: package),
            ),
            if (package == null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60.s),
                child: EmptyState(
                  message: state is PackageError
                      ? state.message.tr()
                      : 'no_trip_details'.tr(),
                  onRetry: cubit.getPackage,
                ),
              )
            else ...[
              Padding(
                padding: EdgeInsets.fromLTRB(20.s, 16.s, 20.s, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (canBook) ...[
                      JourneySupervisorsCard(supervisors: package.supervisors),
                      SizedBox(height: 8.s),
                    ],
                    TripStatGrid(package: package),
                    SizedBox(height: 20.s),
                    Text(
                      'trip_details'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 12.s),
                  ],
                ),
              ),
              for (final section in sections)
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 12.s),
                  child: JourneySectionTile(
                    section: section,
                    onTap: () => _openSection(context, section.section),
                  ),
                ),
              if (bookingId != null) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 12.s),
                  child: Text(
                    'my_bookings_and_payments'.tr(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                for (final section in JourneySectionModel.bookingCatalogue)
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 12.s),
                    child: JourneySectionTile(
                      section: section,
                      onTap: () => _openSection(context, section.section),
                    ),
                  ),
              ],
            ],
            SizedBox(height: 12.s),
          ],
        );
      },
    );
  }
}
