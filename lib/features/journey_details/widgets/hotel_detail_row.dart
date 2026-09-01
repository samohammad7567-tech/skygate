import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';

/// One "تفاصيل الحجز" line: glyph plate, the field label, and its value.
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

  /// Rendered under the value — the map preview uses it.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGlyphPlate(asset: asset, size: 42, glyphSize: 20),
          const SizedBox(width: 12),
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
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                if (child != null) ...[const SizedBox(height: 10), child!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
