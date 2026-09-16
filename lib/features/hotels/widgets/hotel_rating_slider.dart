import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/hotels/models/hotel_filter.dart';

class HotelRatingSlider extends StatelessWidget {
  const HotelRatingSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'hotel_rating'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(0)} ',
              maxLines: 1,
              style: theme.textTheme.titleSmall,
            ),
            AppImage(
              JourneyAssets.star,
              height: 16.s,
              width: 16.s,
              color: AppColors.accent,
            ),
          ],
        ),
        Slider(
          value: value,
          divisions: HotelFilter.maxRating.toInt(),
          max: HotelFilter.maxRating,
          label: value.toStringAsFixed(0),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
