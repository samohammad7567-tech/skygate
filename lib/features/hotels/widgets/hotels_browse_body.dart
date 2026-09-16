import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/app_search_bar.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/hotels/controller/cubit/hotels_browse_cubit.dart';
import 'package:skygate/features/hotels/widgets/hotel_filter_sheet.dart';
import 'package:skygate/features/journey_details/views/hotel_details_screen.dart';
import 'package:skygate/core/components/hotel_card.dart';

class HotelsBrowseBody extends StatefulWidget {
  const HotelsBrowseBody({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  State<HotelsBrowseBody> createState() => _HotelsBrowseBodyState();
}

class _HotelsBrowseBodyState extends State<HotelsBrowseBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final cubit = context.read<HotelsBrowseCubit>();
    final filter = await HotelFilterSheet.show(context, filter: cubit.filter);
    if (filter != null) cubit.applyFilter(filter);
  }

  void _openHotel(HotelModel hotel) => NaivgatorHelper.pushNavigation(
    context,
    HotelDetailsScreen.browse(hotel: hotel),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HotelsBrowseCubit, HotelsBrowseState>(
          builder: (context, state) {
            final cubit = context.read<HotelsBrowseCubit>();

            return Column(
              children: [
                AppPageHeader(
                  title: 'hotels'.tr(),
                  onMenuTap: widget.onMenuTap,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 12.s),
                  child: AppSearchBar(
                    controller: _searchController,
                    hintKey: 'search_hotel_hint',
                    onSubmitted: cubit.search,
                    actionAsset: JourneyAssets.sort,
                    actionTooltip: 'filter_hotels'.tr(),
                    onActionTap: _openFilters,
                  ),
                ),
                Expanded(child: _list(state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(HotelsBrowseState state, HotelsBrowseCubit cubit) {
    if (state is HotelsBrowseLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.hotels.isNotEmpty,
      builder: (_) => RefreshIndicator(
        onRefresh: cubit.getHotels,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 20.s),
          itemCount: cubit.hotels.length,
          separatorBuilder: (_, _) => SizedBox(height: 12.s),
          itemBuilder: (_, index) {
            final hotel = cubit.hotels[index];
            return HotelCard(hotel: hotel, onTap: () => _openHotel(hotel));
          },
        ),
      ),
      fallback: (_) => EmptyState(
        message: state is HotelsBrowseError
            ? state.message.tr()
            : 'no_hotels'.tr(),
        onRetry: cubit.getHotels,
      ),
    );
  }
}
