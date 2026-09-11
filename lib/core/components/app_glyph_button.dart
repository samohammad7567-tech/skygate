import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

/// A flat 36px tap target around a bundled glyph — the chevrons stepping the
/// map's date bar, the attach and mic buttons of the support composer.
///
/// Unlike [AppCircleIconButton] this carries no surface or elevation: it sits
/// directly on whatever it is placed over.
class AppGlyphButton extends StatelessWidget {
  const AppGlyphButton({
    super.key,
    required this.asset,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.size = 36,
    this.glyphSize = 18,
    this.mirrorInRtl = false,
  });

  final String asset;

  /// Already-translated tooltip text.
  final String tooltip;

  final VoidCallback onTap;

  /// Tint of the glyph. Defaults to the theme's primary colour.
  final Color? color;

  final double size;
  final double glyphSize;

  /// Flips the glyph horizontally under RTL. Set it on a directional export —
  /// an arrow drawn the way an LTR reader expects — so that in either language
  /// the button on the start side points backwards.
  final bool mirrorInRtl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget glyph = AppImage(
      asset,
      height: glyphSize,
      width: glyphSize,
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
      constraints: BoxConstraints.tightFor(width: size, height: size),
      padding: EdgeInsets.zero,
      icon: glyph,
    );
  }
}
