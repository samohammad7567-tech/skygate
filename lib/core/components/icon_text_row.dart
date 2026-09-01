import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

/// Glyph on the start side with a single line of copy after it — the shape
/// every hotel-card detail and activity time uses.
class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key,
    required this.asset,
    required this.text,
    this.iconColor,
    this.textStyle,
    this.iconSize = 16,
  });

  final String asset;
  final String text;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        AppImage(
          asset,
          height: iconSize,
          width: iconSize,
          color: iconColor ?? theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
