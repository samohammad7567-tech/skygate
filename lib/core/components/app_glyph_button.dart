import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppGlyphButton extends StatelessWidget {
  const AppGlyphButton({
    super.key,
    required this.asset,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.size,
    this.glyphSize,
    this.mirrorInRtl = false,
  });

  final String asset;
  final String tooltip;

  final VoidCallback onTap;
  final Color? color;

  final double? size;
  final double? glyphSize;
  final bool mirrorInRtl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget glyph = AppImage(
      asset,
      height: (glyphSize ?? 18.s),
      width: (glyphSize ?? 18.s),
      color: color ?? theme.colorScheme.primary,
    );

    if (mirrorInRtl) {
      glyph = Transform.flip(
        flipX: Directionality.of(context) == TextDirection.rtl,
        child: glyph,
      );
    }

    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      constraints: BoxConstraints.tightFor(
        width: (size ?? 36.s),
        height: (size ?? 36.s),
      ),
      padding: EdgeInsets.zero,
      icon: glyph,
    );
  }
}
