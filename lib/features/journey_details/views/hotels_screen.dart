import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/controller/cubit/hotels_cubit.dart';
import 'package:skygate/features/journey_details/views/hotel_details_screen.dart';
import 'package:skygate/features/journey_details/widgets/hotel_card.dart';
import 'package:skygate/features/journey_details/widgets/hotel_search_bar.dart';

/// "الفنادق" — searchable, sortable list of the package's hotels.
class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotelsCubit(tripId)..getHotels(),
      child: const _HotelsBody(),
    );
  }
}

class _HotelsBody extends StatefulWidget {
  const _HotelsBody();

  @override
  State<_HotelsBody> createState() => _HotelsBodyState();
}

class _HotelsBodyState extends State<_HotelsBody> {
  /// Owned by the screen; the cubit only keeps the value it last searched for.
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickSort() async {
    final cubit = context.read<HotelsCubit>();
    final picked = await showModalBottomSheet<HotelSort>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final sort in HotelSort.values)
              ListTile(
                title: Text(sort.labelKey.tr()),
                trailing: sort == cubit.sort
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(sort),
              ),
          ],
        ),
      ),
    );
    if (picked != null) cubit.changeSort(picked);
  }

  void _openHotel(HotelModel hotel) => NaivgatorHelper.pushNavigation(
    context,
    HotelDetailsScreen(
      tripId: context.read<HotelsCubit>().tripId,
      hotel: hotel,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HotelsCubit, HotelsState>(
          builder: (context, state) {
            final cubit = context.read<HotelsCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'hotels'.tr()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: HotelSearchBar(
                    controller: _searchController,
                    onSubmitted: cubit.search,
                    onSortTap: _pickSort,
                  ),
                ),
                Expanded(child: _body(context, state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(BuildContext context, HotelsState state, HotelsCubit cubit) {
    if (state is HotelsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.hotels.isNotEmpty,
      builder: (_) => RefreshIndicator(
        onRefresh: () => cubit.getHotels(refresh: true),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: cubit.hotels.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final hotel = cubit.hotels[index];
            return HotelCard(hotel: hotel, onTap: () => _openHotel(hotel));
          },
        ),
      ),
      fallback: (_) => EmptyState(
        message: state is HotelsError ? state.message.tr() : 'no_hotels'.tr(),
        onRetry: () => cubit.getHotels(refresh: true),
      ),
    );
  }
}
