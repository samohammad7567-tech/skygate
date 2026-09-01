import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/views/booking_type_screen.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';
import 'package:skygate/features/journey_details/views/activities_screen.dart';
import 'package:skygate/features/journey_details/views/hotels_screen.dart';
import 'package:skygate/features/journey_details/views/itinerary_screen.dart';
import 'package:skygate/features/journey_details/views/trip_offers_screen.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/journey_hero_header.dart';
import 'package:skygate/features/journey_details/widgets/journey_section_tile.dart';
import 'package:skygate/features/journey_details/widgets/journey_stays_row.dart';
import 'package:skygate/features/journey_details/widgets/journey_supervisors_card.dart';

/// "رحلة مكة" — the package overview and the four rows that open the rest of
/// the flow.
class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JourneyDetailsCubit(tripId)..getPackage(),
      child: const _PackageDetailsBody(),
    );
  }
}

class _PackageDetailsBody extends StatelessWidget {
  const _PackageDetailsBody();

  /// "إبدأ عملية الحجز" — hands the package over to the six-step wizard.
  void _startBooking(BuildContext context) {
    NaivgatorHelper.pushNavigation(
      context,
      BookingTypeScreen(tripId: context.read<JourneyDetailsCubit>().tripId),
    );
  }

  void _openSection(BuildContext context, JourneySection section) {
    final tripId = context.read<JourneyDetailsCubit>().tripId;

    NaivgatorHelper.pushNavigation(context, switch (section) {
      JourneySection.routes => ItineraryScreen(tripId: tripId),
      JourneySection.hotels => HotelsScreen(tripId: tripId),
      JourneySection.activities => const ActivitiesScreen(),
      JourneySection.offers => TripOffersScreen(tripId: tripId),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
        builder: (context, state) {
          final cubit = context.read<JourneyDetailsCubit>();
          final package = cubit.package;

          if (state is PackageLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              JourneyHeroHeader(
                image: package?.image,
                durationDays: package?.durationDays,
              ),
              if (package == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: EmptyState(
                    message: state is PackageError
                        ? state.message.tr()
                        : 'no_trip_details'.tr(),
                    onRetry: cubit.getPackage,
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        package.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      JourneySupervisorsCard(supervisors: package.supervisors),
                      const SizedBox(height: 12),
                      JourneyStaysRow(stays: package.stays),
                      const SizedBox(height: 20),
                      Text(
                        'trip_details'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                for (final section in cubit.sections)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: JourneySectionTile(
                      section: section,
                      onTap: () => _openSection(context, section.section),
                    ),
                  ),
              ],
              const SizedBox(height: 12),
            ],
          );
        },
      ),
      bottomNavigationBar: JourneyBottomBar(
        label: 'start_booking'.tr(),
        onPressed: () => _startBooking(context),
      ),
    );
  }
}
