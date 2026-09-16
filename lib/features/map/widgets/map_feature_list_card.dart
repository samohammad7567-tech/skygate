import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/utils/app_scale.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 6.s),
      radius: 16.s,
      child: Column(
        children: [
          for (var i = 0; i < features.length; i++) ...[
            if (i > 0) Divider(height: 1.s),
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
      padding: EdgeInsets.symmetric(vertical: 12.s),
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
                  SizedBox(height: 4.s),
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
          SizedBox(width: 12.s),
          AppGlyphPlate(
            asset: feature.icon,
            size: 40.s,
            glyphSize: 20.s,
            color: accent,
            background: accent.withValues(alpha: 0.10),
          ),
        ],
      ),
    );
  }
}
