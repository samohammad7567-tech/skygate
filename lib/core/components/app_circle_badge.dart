import 'package:flutter/material.dart';

/// A filled circle carrying a short piece of text — a traveller's place in the
/// group, the beds a lock covers, an instalment's share of the total.
///
/// Sized and tinted by the caller because the flows draw it at anything from
/// an 18px counter pill to a 48px instalment badge.
class AppCircleBadge extends StatelessWidget {
  const AppCircleBadge({
    super.key,
    required this.text,
    this.size = 18,
    this.background,
    this.foreground,
    this.textStyle,
  });

  /// Already-formatted content — "3", "٢", "25%". Kept as text rather than a
  /// number so the badge never has to know how a flow words its value.
  final String text;

  /// Diameter of the circle.
  final double size;

  /// Defaults to the theme's primary colour.
  final Color? background;

  /// Colour of [text]. Defaults to the theme's `onPrimary`.
  final Color? foreground;

  /// Defaults to the theme's `titleSmall`.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: size,
      width: size,
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
