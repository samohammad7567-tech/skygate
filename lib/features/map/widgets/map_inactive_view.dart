import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/constants/map_assets.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        AppCard(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
          radius: 16,
          child: Column(
            children: [
              MapDashedRing(
                size: 170,
                child: _CrossedPin(color: theme.colorScheme.onSurface),
              ),
              const Gap(22),
              Text(
                'map_inactive_title'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              const Gap(10),
              Text(
                'map_inactive_desc'.tr(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        const Gap(14),
        MapFeatureListCard(
          features: MapFeatureModel.inactive,
          accent: theme.colorScheme.primary,
        ),
        const Gap(18),
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
      height: 84,
      width: 84,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppImage(MapAssets.trackingOff, height: 66, width: 66, color: muted),
          PositionedDirectional(
            bottom: 6,
            start: 4,
            child: Container(
              height: 28,
              width: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: muted, width: 1.4),
              ),
              child: AppImage(
                MapAssets.cross,
                height: 14,
                width: 14,
                color: muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
