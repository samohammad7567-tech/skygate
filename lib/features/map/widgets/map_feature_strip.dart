import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';

class MapFeatureStrip extends StatelessWidget {
  const MapFeatureStrip({super.key, required this.features});

  final List<MapFeatureModel> features;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final feature in features)
          Expanded(child: _FeatureChip(feature: feature)),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.feature});

  final MapFeatureModel feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppImage(
          feature.icon,
          height: 26,
          width: 26,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          feature.titleKey.tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
