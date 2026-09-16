import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppGlyphPlate extends StatelessWidget {
  const AppGlyphPlate({
    super.key,
    this.asset,
    this.icon,
    this.size,
    this.glyphSize,
    this.color,
    this.background,
  }) : assert(asset != null || icon != null, 'pass an asset or an icon');
  final String? asset;
  final IconData? icon;

  final double? size;
  final double? glyphSize;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = color ?? theme.colorScheme.primary;

    return Container(
      height: (size ?? 40.s),
      width: (size ?? 40.s),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: asset != null
          ? AppImage(
              asset!,
              height: (glyphSize ?? 20.s),
              width: (glyphSize ?? 20.s),
              color: foreground,
            )
          : Icon(icon, size: (glyphSize ?? 20.s), color: foreground),
    );
  }
}
