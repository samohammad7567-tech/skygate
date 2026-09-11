import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';

class MapFeatureListCard extends StatelessWidget {
  const MapFeatureListCard({
    super.key,
    required this.features,
    required this.accent,
  });

  final List<MapFeatureModel> features;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      radius: 16,
      child: Column(
        children: [
          for (var i = 0; i < features.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _FeatureRow(feature: features[i], accent: accent),
          ],
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature, required this.accent});

  final MapFeatureModel feature;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleKey = feature.subtitleKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  feature.titleKey.tr(),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(color: accent),
                ),
                if (subtitleKey != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitleKey.tr(),
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppGlyphPlate(
            asset: feature.icon,
            size: 40,
            glyphSize: 20,
            color: accent,
            background: accent.withValues(alpha: 0.10),
          ),
        ],
      ),
    );
  }
}
