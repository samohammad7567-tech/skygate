import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

class AppCircleIconButton extends StatelessWidget {
  const AppCircleIconButton({
    super.key,
    required this.asset,
    this.onTap,
    this.tooltip,
    this.size = 40,
    this.glyphSize = 18,
    this.mirrorInRtl = false,
  });

  final String asset;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;
  final double glyphSize;

  /// Turns the glyph over under RTL. Set it for anything that points
  /// somewhere — an arrow means "backwards", and backwards is to the right in
  /// Arabic. Plain glyphs (a calendar, a menu) must leave it off.
  final bool mirrorInRtl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.15),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Center(
            child: Transform.scale(
              scaleX:
                  mirrorInRtl &&
                      Directionality.of(context) == TextDirection.rtl
                  ? -1
                  : 1,
              child: AppImage(
                asset,
                height: glyphSize,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
