import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

InputDecoration appInputDecoration(
  BuildContext context, {
  required String hint,
  required String icon,
  VoidCallback? onIconTap,
  bool filled = false,
}) {
  final theme = Theme.of(context);
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.s),
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
    contentPadding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 15.s),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4.s),
    ),
    errorBorder: border.copyWith(
      borderSide: BorderSide(color: theme.colorScheme.error),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4.s),
    ),
    errorStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    ),
    suffixIcon: AppFieldIcon(asset: icon, onTap: onIconTap),
    suffixIconConstraints: BoxConstraints(minWidth: 46.s),
  );
}

class AppFieldIcon extends StatelessWidget {
  const AppFieldIcon({super.key, required this.asset, this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = AppImage(
      asset,
      height: 22.s,
      color: Theme.of(context).colorScheme.primary,
    );

    return Padding(
      padding: EdgeInsetsDirectional.only(end: 12.s, start: 8.s),
      child: onTap == null
          ? image
          : GestureDetector(onTap: onTap, child: image),
    );
  }
}
