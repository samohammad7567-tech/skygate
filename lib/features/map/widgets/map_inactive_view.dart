import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';
import 'package:skygate/features/map/widgets/map_dashed_ring.dart';
import 'package:skygate/features/map/widgets/map_feature_list_card.dart';

class MapInactiveView extends StatelessWidget {
  const MapInactiveView({super.key, required this.onBrowseTrips});

  final VoidCallback onBrowseTrips;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 120.s),
      children: [
        AppCard(
          padding: EdgeInsets.fromLTRB(18.s, 24.s, 18.s, 22.s),
          radius: 16.s,
          child: Column(
            children: [
              MapDashedRing(
                size: 170.s,
                child: _CrossedPin(color: theme.colorScheme.onSurface),
              ),
              Gap(22.s),
              Text(
                'map_inactive_title'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              Gap(10.s),
              Text(
                'map_inactive_desc'.tr(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.7.s,
                ),
              ),
            ],
          ),
        ),
        Gap(14.s),
        MapFeatureListCard(
          features: MapFeatureModel.inactive,
          accent: theme.colorScheme.primary,
        ),
        Gap(18.s),
        AppOutlinedButton(
          label: 'map_browse_trips'.tr(),
          onPressed: onBrowseTrips,
        ),
      ],
    );
  }
}

class _CrossedPin extends StatelessWidget {
  const _CrossedPin({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = color.withValues(alpha: 0.45);

    return SizedBox(
      height: 84.s,
      width: 84.s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppImage(
            MapAssets.trackingOff,
            height: 66.s,
            width: 66.s,
            color: muted,
          ),
          PositionedDirectional(
            bottom: 6.s,
            start: 4.s,
            child: Container(
              height: 28.s,
              width: 28.s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: muted, width: 1.4.s),
              ),
              child: AppImage(
                MapAssets.cross,
                height: 14.s,
                width: 14.s,
                color: muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
