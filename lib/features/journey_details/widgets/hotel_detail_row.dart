import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/utils/app_scale.dart';

class HotelDetailRow extends StatelessWidget {
  const HotelDetailRow({
    super.key,
    required this.asset,
    required this.labelKey,
    required this.value,
    this.child,
  });

  final String asset;
  final String labelKey;
  final String value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGlyphPlate(asset: asset, size: 42.s, glyphSize: 20.s),
          SizedBox(width: 12.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.s),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                if (child != null) ...[SizedBox(height: 10.s), child!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
