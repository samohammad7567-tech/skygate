import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/home_assets.dart';

/// Full-bleed trip photo with the back chip on the end side and the trip
/// length badge on the start side.
class JourneyHeroHeader extends StatelessWidget {
  const JourneyHeroHeader({super.key, this.image, this.durationDays});

  final String? image;
  final int? durationDays;

  static const double height = 230;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedImage(
            url: image,
            fallbackAsset: HomeAssets.kaaba,
            height: height,
            width: double.infinity,
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (durationDays != null) _DurationBadge(days: durationDays!),
                  const Spacer(),
                  const AppBackButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Orange "٧ أيام" pill floating over the photo.
class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(HomeAssets.clock, height: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            'days_count'.tr(namedArgs: {'count': '$days'}),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
