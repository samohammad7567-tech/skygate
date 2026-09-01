import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/journey_details/controller/cubit/hotels_cubit.dart';
import 'package:skygate/features/journey_details/widgets/hotel_detail_row.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';

/// "تفاصيل الحجز" — the booked hotel, field by field, with its map.
class HotelDetailsScreen extends StatelessWidget {
  const HotelDetailsScreen({
    super.key,
    required this.tripId,
    required this.hotel,
  });

  final int tripId;

  /// The hotel as the list knows it — which is everything the API publishes
  /// about it.
  final HotelModel hotel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotelsCubit(tripId)..showHotel(hotel),
      child: const _HotelDetailsBody(),
    );
  }
}

class _HotelDetailsBody extends StatelessWidget {
  const _HotelDetailsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HotelsCubit, HotelsState>(
          builder: (context, state) {
            final hotel = context.read<HotelsCubit>().hotel;

            return Column(
              children: [
                AppPageHeader(title: 'booking_details'.tr()),
                Expanded(
                  child: hotel == null
                      ? const Center(child: CircularProgressIndicator())
                      : _HotelContent(hotel: hotel),
                ),
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
}

class _HotelContent extends StatelessWidget {
  const _HotelContent({required this.hotel});

  final HotelModel hotel;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        CachedImage(
          url: hotel.image,
          fallbackAsset: JourneyAssets.hotelPhoto,
          height: 190,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HotelDetailRow(
                  asset: JourneyAssets.hotel,
                  labelKey: 'hotel_name',
                  value: hotel.name ?? '—',
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.city,
                  labelKey: 'hotel_city',
                  value: hotel.city ?? '—',
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.location,
                  labelKey: 'hotel_address',
                  value: hotel.address ?? '—',
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.star,
                  labelKey: 'hotel_rating',
                  value: hotel.rating == null
                      ? '—'
                      : 'stars_count'.tr(
                          namedArgs: {'count': '${hotel.rating}'},
                        ),
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.calendar,
                  labelKey: 'check_in_date',
                  value: AppFormat.shortDate(hotel.checkIn, locale),
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.calendar,
                  labelKey: 'check_out_date',
                  value: AppFormat.shortDate(hotel.checkOut, locale),
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.nights,
                  labelKey: 'nights_number',
                  value: hotel.nights == null
                      ? '—'
                      : 'nights_count'.tr(
                          namedArgs: {'count': '${hotel.nights}'},
                        ),
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.bed,
                  labelKey: 'room_types',
                  value: hotel.roomTypes ?? '—',
                ),
                const Divider(height: 1),
                HotelDetailRow(
                  asset: JourneyAssets.map,
                  labelKey: 'map_location',
                  value: hotel.mapNote ?? '—',
                  // The map exports are 3:2; holding that ratio keeps the
                  // labels on them from being cropped away.
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedImage(
                        url: hotel.mapImage,
                        fallbackAsset: JourneyAssets.hotelMap,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
