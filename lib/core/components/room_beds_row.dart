import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';

/// One bed glyph per sleeper the room takes, under its name.
class RoomBedsRow extends StatelessWidget {
  const RoomBedsRow({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      children: [
        for (var i = 0; i < count; i++)
          AppImage(
            JourneyAssets.bed,
            height: 14,
            width: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }
}

/// "البالغ" with its glyph on the end side, the orange price on the start.
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
        const Gap(8),
        AppImage(
          JourneyAssets.adult,
          height: 18,
          width: 18,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}

/// Red outlined pill warning that the room is nearly booked out.
class AlmostFullChip extends StatelessWidget {
  const AlmostFullChip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
