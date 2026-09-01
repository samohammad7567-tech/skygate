import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

/// Single source of truth for the auth field chrome, shared by the text, date
/// and dropdown variants so they line up pixel for pixel.
///
/// The glyph goes in the suffix slot: that puts it on the left under Arabic and
/// on the right under English, matching the mockups in both directions.
InputDecoration appInputDecoration(
  BuildContext context, {
  required String hint,
  required String icon,
  VoidCallback? onIconTap,
  bool filled = false,
}) {
  final theme = Theme.of(context);
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: theme.colorScheme.outline),
  );

  return InputDecoration(
    hintText: hint,
    hintStyle: theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
    ),
    filled: true,
    fillColor: filled
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surface,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
    ),
    errorBorder: border.copyWith(
      borderSide: BorderSide(color: theme.colorScheme.error),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
    ),
    errorStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    ),
    suffixIcon: AppFieldIcon(asset: icon, onTap: onIconTap),
    suffixIconConstraints: const BoxConstraints(minWidth: 46),
  );
}

/// The tinted glyph rendered inside [appInputDecoration].
class AppFieldIcon extends StatelessWidget {
  const AppFieldIcon({super.key, required this.asset, this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = AppImage(
      asset,
      height: 22,
      color: Theme.of(context).colorScheme.primary,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 12, start: 8),
      child: onTap == null
          ? image
          : GestureDetector(onTap: onTap, child: image),
    );
  }
}
