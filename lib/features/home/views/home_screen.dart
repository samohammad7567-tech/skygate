import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/utils/screen_size.dart';
import 'package:skygate/features/home/controller/cubit/home_cubit.dart';
import 'package:skygate/features/home/widgets/current_offers_section.dart';
import 'package:skygate/features/home/widgets/custom_trip_section.dart';
import 'package:skygate/features/home/widgets/hero_search_card.dart';
import 'package:skygate/features/home/widgets/home_header.dart';
import 'package:skygate/features/home/widgets/services_section.dart';
import 'package:skygate/features/home/widgets/travel_categories_bar.dart';
import 'package:skygate/features/journey_details/views/package_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getOffers();
  }

  Future<void> _pickTravelDate() async {
    final cubit = context.read<HomeCubit>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.travelDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) cubit.selectTravelDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is CustomTripSubmitted) {
              showToast(context, 'we_send_approval_soon'.tr());
            } else if (state is CustomTripError) {
              showToast(context, state.message.tr(), isError: true);
            }
          },
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => cubit.getOffers(),
                  edgeOffset: HomeHeader.height,
                  child: ListView(
                    padding: const EdgeInsets.only(
                      // The header is painted on top of the list so its shadow
                      // falls over the hero photo, so the list reserves its
                      // height here instead of holding it as an item.
                      top: HomeHeader.height,
                      bottom: 120,
                    ),
                    children: [
                      HeroSearchCard(
                        travelDate: cubit.travelDate,
                        onPickDate: _pickTravelDate,
                        onSearch: () => cubit.getOffers(),
                      ),
                      const SizedBox(height: 12),
                      TravelCategoriesBar(
                        categories: cubit.categories,
                        selectedId: cubit.selectedCategoryId,
                        onSelected: (id) {
                          cubit.selectCategory(id);
                          cubit.getOffers();
                        },
                      ),
                      const SizedBox(height: 8),
                      CurrentOffersSection(
                        offers: cubit.offers,
                        isLoading: state is OffersLoading,
                        errorMessage: state is OffersError
                            ? state.message.tr()
                            : null,
                        onRetry: () => cubit.getOffers(),
                        onViewAll: () {},
                        onOfferTap: (offer) => NaivgatorHelper.pushNavigation(
                          context,
                          PackageDetailsScreen(tripId: offer.id ?? 0),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ServicesSection(services: cubit.services),
                      const SizedBox(height: 24),
                      CustomTripSection(
                        isSubmitting: state is CustomTripLoading,
                        onRequest: cubit.requestCustomTrip,
                      ),
                    ],
                  ),
                ),
                HomeHeader(onMenuTap: () {}, onNotificationsTap: () {}),
              ],
            );
          },
        ),
      ),
    );
  }
}
