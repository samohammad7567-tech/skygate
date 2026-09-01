import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';

/// Name, city, rating, nights and address — the block a hotel card prints on
/// the start side of its photo.
class GroupHotelSummary extends StatelessWidget {
  const GroupHotelSummary({super.key, required this.hotel});

  final HotelModel hotel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
          text: 'nights_count'.tr(namedArgs: {'count': '${hotel.nights ?? 0}'}),
        ),
        const Gap(4),
        IconTextRow(asset: JourneyAssets.location, text: hotel.address ?? ''),
      ],
    );
  }
}
