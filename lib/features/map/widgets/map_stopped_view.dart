import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';
import 'package:skygate/features/map/widgets/map_feature_list_card.dart';

class MapStoppedView extends StatelessWidget {
  const MapStoppedView({super.key, required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          radius: 16,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AppImage(
                  MapAssets.trackingStopped,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                child: Column(
                  children: [
                    Text(
                      'map_stopped_title'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'map_stopped_desc'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(14),
        const MapFeatureListCard(
          features: MapFeatureModel.stopped,
          accent: AppColors.success,
        ),
        const Gap(18),
        CustomButton(
          label: 'map_back_home'.tr(),
          height: 48,
          onPressed: onGoHome,
          icon: AppImage(
            MapAssets.home,
            height: 18,
            width: 18,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
