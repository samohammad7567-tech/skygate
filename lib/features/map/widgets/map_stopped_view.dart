import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';
import 'package:skygate/features/map/widgets/map_feature_list_card.dart';

class MapStoppedView extends StatelessWidget {
  const MapStoppedView({super.key, required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 120.s),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          radius: 16.s,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.s)),
                child: AppImage(
                  MapAssets.trackingStopped,
                  height: 200.vs,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.s, 18.s, 18.s, 22.s),
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
                    Gap(10.s),
                    Text(
                      'map_stopped_desc'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                        height: 1.7.s,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(14.s),
        const MapFeatureListCard(
          features: MapFeatureModel.stopped,
          accent: AppColors.success,
        ),
        Gap(18.s),
        CustomButton(
          label: 'map_back_home'.tr(),
          height: 48.s,
          onPressed: onGoHome,
          icon: AppImage(
            MapAssets.home,
            height: 18.s,
            width: 18.s,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
