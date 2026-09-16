import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class CustomTripFeatures extends StatelessWidget {
  const CustomTripFeatures({super.key});

  static const List<(String, String)> _features = [
    (HomeAssets.supportAgent, 'feature_direct_contact'),
    (HomeAssets.calendar, 'feature_flexible_dates'),

    (HomeAssets.tripBag, 'feature_custom_trip'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _features.length; i++) ...[
            if (i > 0)
              VerticalDivider(width: 13.s, color: theme.colorScheme.outline),
            Expanded(
              child: _Feature(
                asset: _features[i].$1,
                labelKey: _features[i].$2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.asset, required this.labelKey});

  final String asset;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage(
          asset,
          width: 22.s,
          height: 22.s,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: 6.s),
        Text(
          labelKey.tr(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
