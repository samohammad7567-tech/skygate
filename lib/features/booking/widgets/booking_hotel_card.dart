import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/components/booking_selectable_card.dart';
import 'package:skygate/core/utils/app_scale.dart';

class BookingHotelCard extends StatelessWidget {
  const BookingHotelCard({
    super.key,
    required this.hotel,
    required this.isSelected,
    required this.onTap,
  });

  final HotelModel hotel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BookingSelectableCard(
      isSelected: isSelected,
      onTap: onTap,
      padding: EdgeInsets.all(10.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.s),
            child: BookingRadio(isSelected: isSelected),
          ),
          Gap(10.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hotel.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Gap(2.s),
                Text(
                  hotel.city ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                Gap(4.s),
                IconTextRow(
                  asset: JourneyAssets.star,
                  iconColor: AppColors.accent,
                  text: '${hotel.rating ?? '—'}',
                  textStyle: theme.textTheme.bodySmall,
                ),
                Gap(4.s),
                IconTextRow(
                  asset: JourneyAssets.nights,
                  text: 'nights_count'.tr(
                    namedArgs: {'count': '${hotel.nights ?? 0}'},
                  ),
                ),
                Gap(4.s),
                IconTextRow(
                  asset: JourneyAssets.location,
                  text: hotel.address ?? '',
                ),
              ],
            ),
          ),
          Gap(10.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.s),
            child: CachedImage(
              url: hotel.image,
              fallbackAsset: JourneyAssets.hotelPhoto,
              height: 116.s,
              width: 124.s,
            ),
          ),
        ],
      ),
    );
  }
}
