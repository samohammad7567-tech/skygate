import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/utils/screen_size.dart';
import 'package:skygate/features/home/controller/cubit/home_cubit.dart';
import 'package:skygate/features/home/models/offer_model.dart';
import 'package:skygate/features/home/utils/travel_category_route.dart';
import 'package:skygate/features/home/widgets/city_picker_sheet.dart';
import 'package:skygate/features/home/widgets/current_offers_section.dart';
import 'package:skygate/features/home/widgets/custom_trip_section.dart';
import 'package:skygate/features/home/widgets/hero_search_card.dart';
import 'package:skygate/features/home/widgets/home_header.dart';
import 'package:skygate/features/home/widgets/notifications_sheet.dart';
import 'package:skygate/features/home/widgets/services_section.dart';
import 'package:skygate/features/home/widgets/travel_categories_bar.dart';
import 'package:skygate/features/journey_details/views/package_details_screen.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_counts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onMenuTap});
  final VoidCallback? onMenuTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHome();
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

  Future<void> _pickCity() async {
    final cubit = context.read<HomeCubit>();
    final result = await CityPickerSheet.show(
      context,
      cities: cubit.cities,
      selected: cubit.selectedCity,
    );
    if (result != null) cubit.selectCity(result.city);
  }

  void _openNotifications() {
    final cubit = context.read<HomeCubit>();
    NotificationsSheet.show(
      context,
      notifications: cubit.notifications,
      onRead: cubit.readNotification,
    );
  }

  void _openOffer(OfferModel offer) {
    final tripId = offer.id;
    if (tripId == null) return;
    NaivgatorHelper.pushNavigation(
      context,
      PackageDetailsScreen(tripId: tripId),
    );
  }

  void _requestPrivateTrip() {
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider(
        create: (_) => VipTripCubit(),
        child: const VipCountsScreen(),
      ),
    );
  }

  void _selectCategory(String id) {
    context.read<HomeCubit>().selectCategory(id);

    final screen = travelCategoryScreen(id);
    if (screen != null) NaivgatorHelper.pushNavigation(context, screen);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.getHome,
                  edgeOffset: HomeHeader.height.s,
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: HomeHeader.height.s,
                      bottom: 120.s,
                    ),
                    children: [
                      HeroSearchCard(
                        travelDate: cubit.travelDate,
                        city: cubit.selectedCity,
                        onPickCity: cubit.cities.isEmpty ? null : _pickCity,
                        onPickDate: _pickTravelDate,
                        onSearch: cubit.searchTrips,
                      ),
                      SizedBox(height: 12.s),
                      TravelCategoriesBar(
                        categories: cubit.categories,
                        selectedId: cubit.selectedCategoryId,
                        onSelected: _selectCategory,
                      ),
                      SizedBox(height: 8.s),
                      CurrentOffersSection(
                        offers: cubit.offers,
                        isLoading: state is HomeLoading,
                        errorMessage: state is HomeError
                            ? state.message.tr()
                            : null,
                        onRetry: cubit.getHome,
                        onViewAll: () {},
                        onOfferTap: _openOffer,
                      ),
                      SizedBox(height: 24.s),
                      ServicesSection(services: cubit.services),
                      SizedBox(height: 24.s),
                      CustomTripSection(onRequest: _requestPrivateTrip),
                    ],
                  ),
                ),
                HomeHeader(
                  onMenuTap: widget.onMenuTap,
                  onNotificationsTap: _openNotifications,
                  unreadCount: cubit.unreadNotifications,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
