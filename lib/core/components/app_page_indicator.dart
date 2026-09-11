import 'package:flutter/material.dart';

/// The row of dots under a pager, the current one stretched into a pill.
///
/// Laid out as a plain [Row], so an RTL locale mirrors it and page 1 lights up
/// the right-most dot — which is what both designs draw. The onboarding copy
/// card and the splash slideshow size and tint it differently, so the two
/// measurements and the resting colour are the caller's to set.
class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.dotSize = 8,
    this.activeWidth = 20,
    this.activeColor,
    this.inactiveColor,
  });

  final int count;
  final int currentIndex;

  /// Diameter of a resting dot, and the height of every dot including the
  /// active pill.
  final double dotSize;

  /// Width the active dot stretches to.
  final double activeWidth;

  /// Defaults to the theme's secondary colour.
  final Color? activeColor;

  /// Defaults to the theme's `outlineVariant`. The splash passes a translucent
  /// white instead, so the dots stay readable over a photo.
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: isActive ? activeWidth : dotSize,
          height: dotSize,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isActive
                ? (activeColor ?? theme.colorScheme.secondary)
                : (inactiveColor ?? theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(dotSize),
          ),
        );
      }),
    );
  }
}
