import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';

class HotelFilterRow extends StatelessWidget {
  const HotelFilterRow({super.key, required this.asset, required this.child});

  final String asset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          AppGlyphPlate(asset: asset, size: 46, glyphSize: 22),
          const SizedBox(width: 14),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class HotelFilterValue extends StatelessWidget {
  const HotelFilterValue({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
