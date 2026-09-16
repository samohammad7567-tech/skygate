import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

class HotelSummary extends StatelessWidget {
  const HotelSummary({super.key, required this.hotel});

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
          text: 'nights_count'.tr(namedArgs: {'count': '${hotel.nights ?? 0}'}),
        ),
        Gap(4.s),
        IconTextRow(asset: JourneyAssets.location, text: hotel.address ?? ''),
      ],
    );
  }
}
