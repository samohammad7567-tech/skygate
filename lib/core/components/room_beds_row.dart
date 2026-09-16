import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class RoomBedsRow extends StatelessWidget {
  const RoomBedsRow({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Wrap(
      spacing: 4.s,
      children: [
        for (var i = 0; i < count; i++)
          AppImage(
            JourneyAssets.bed,
            height: 14.s,
            width: 14.s,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }
}

class RoomPriceRow extends StatelessWidget {
  const RoomPriceRow({super.key, required this.price, required this.currency});

  final num? price;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          price == null ? '—' : '$price${currency ?? ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const Spacer(),
        Text(
          'price_adult'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Gap(8.s),
        AppImage(
          JourneyAssets.adult,
          height: 18.s,
          width: 18.s,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}

class AlmostFullChip extends StatelessWidget {
  const AlmostFullChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.s, vertical: 7.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.s),
        border: Border.all(color: AppColors.error),
      ),
      child: Text(
        'almost_full'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.error),
      ),
    );
  }
}
