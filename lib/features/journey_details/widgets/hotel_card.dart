import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';

/// One card in "الفنادق": the cover on the start side, the summary after it.
class HotelCard extends StatelessWidget {
  const HotelCard({super.key, required this.hotel, this.onTap});

  final HotelModel hotel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedImage(
              url: hotel.image,
              fallbackAsset: JourneyAssets.hotelPhoto,
              height: 122,
              width: 128,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  hotel.city ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                IconTextRow(
                  asset: JourneyAssets.star,
                  iconColor: AppColors.accent,
                  text: '${hotel.rating ?? '—'}',
                  textStyle: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                IconTextRow(
                  asset: JourneyAssets.nights,
                  text: 'nights_count'.tr(
                    namedArgs: {'count': '${hotel.nights ?? 0}'},
                  ),
                ),
                const SizedBox(height: 4),
                IconTextRow(
                  asset: JourneyAssets.location,
                  text: hotel.address ?? '',
                ),
                // The trip endpoint publishes no room types; the row appears
                // only once one is known.
                if (hotel.roomTypes case final rooms?) ...[
                  const SizedBox(height: 4),
                  IconTextRow(asset: JourneyAssets.bed, text: rooms),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
