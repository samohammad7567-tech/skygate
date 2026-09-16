import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class JourneyHeroHeader extends StatelessWidget {
  const JourneyHeroHeader({super.key, this.image, this.durationDays});

  final String? image;
  final int? durationDays;

  static const double height = 230;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.vs,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedImage(
            url: image,
            fallbackAsset: HomeAssets.kaaba,
            height: height.vs,
            width: double.infinity,
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 12.s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  if (durationDays != null) _DurationBadge(days: durationDays!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 6.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(8.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(HomeAssets.clock, height: 14.s, color: Colors.white),
          SizedBox(width: 6.s),
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
