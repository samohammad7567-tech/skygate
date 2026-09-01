import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/features/booking/widgets/booking_selectable_card.dart';

/// One card on "اختر فندق مكة المكرمة": the radio, the hotel summary, then the
/// cover photo on the end side.
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
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: BookingRadio(isSelected: isSelected),
          ),
          const Gap(10),
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
                const Gap(2),
                Text(
                  hotel.city ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const Gap(4),
                IconTextRow(
                  asset: JourneyAssets.star,
                  iconColor: AppColors.accent,
                  text: '${hotel.rating ?? '—'}',
                  textStyle: theme.textTheme.bodySmall,
                ),
                const Gap(4),
                IconTextRow(
                  asset: JourneyAssets.nights,
                  text: 'nights_count'.tr(
                    namedArgs: {'count': '${hotel.nights ?? 0}'},
                  ),
                ),
                const Gap(4),
                IconTextRow(
                  asset: JourneyAssets.location,
                  text: hotel.address ?? '',
                ),
              ],
            ),
          ),
          const Gap(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedImage(
              url: hotel.image,
              fallbackAsset: JourneyAssets.hotelPhoto,
              height: 116,
              width: 124,
            ),
          ),
        ],
      ),
    );
  }
}
