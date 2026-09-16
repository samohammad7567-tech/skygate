import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppCircleBadge extends StatelessWidget {
  const AppCircleBadge({
    super.key,
    required this.text,
    this.size,
    this.background,
    this.foreground,
    this.textStyle,
  });
  final String text;
  final double? size;
  final Color? background;
  final Color? foreground;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: (size ?? 18.s),
      width: (size ?? 18.s),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: (textStyle ?? theme.textTheme.titleSmall)?.copyWith(
          color: foreground ?? theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
