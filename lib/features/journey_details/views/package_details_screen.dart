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

/// "تفاصيل الرحلة" — one trip, read two different ways.
///
/// The default constructor is a trip being **browsed**: everything is on show
/// including its packages, and the page ends in "بدء الحجز".
///
/// [PackageDetailsScreen.booked] is a trip from "رحلاتي" — one the pilgrim
/// already holds. Nothing is for sale there, so the offers row and the booking
/// bar both go, and "حجوزاتي و المدفوعات" appears in their place.
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

  /// The booking this pilgrim holds on the trip. Every screen reached from
  /// here is scoped to it — the roster, the cards, the visas and the tickets
  /// are all "whose", not "which trip's".
  final int? bookingId;

  /// Whether the trip can still be bought from this page.
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
      // Both are only ever reachable while `bookingId` is set, which is what
      // put the rows on the page to begin with.
      JourneySection.booking => PaymentsScreen(bookingId: bookingId!),
      JourneySection.cards => TripCardsScreen(bookingId: bookingId!),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The header sits outside the scroll area on purpose: the way back has
      // to stay reachable however far down the page the reader has got.
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
      // Nothing is bought from "رحلاتي"; the trip is already the pilgrim's.
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
            // The design opens on the trip itself rather than on a photo:
            // which trip is running, its number, and both ends of it.
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

                    // Who is running the trip is part of deciding whether to
                    // book it. On a trip already held, the design goes
                    // straight from the four facts to what is inside it.
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
