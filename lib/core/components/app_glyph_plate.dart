import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

class AppGlyphPlate extends StatelessWidget {
  const AppGlyphPlate({
    super.key,
    this.asset,
    this.icon,
    this.size = 40,
    this.glyphSize = 20,
    this.color,
    this.background,
  }) : assert(asset != null || icon != null, 'pass an asset or an icon');
  final String? asset;
  final IconData? icon;

  final double size;
  final double glyphSize;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = color ?? theme.colorScheme.primary;

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: asset != null
          ? AppImage(
              asset!,
              height: glyphSize,
              width: glyphSize,
              color: foreground,
            )
          : Icon(icon, size: glyphSize, color: foreground),
    );
  }
}
