import 'package:flutter/material.dart';

/// Slideshow dots above the title.
///
/// The active slide is a wide accent pill, the rest are translucent white dots
/// so they stay readable on the photo. Laid out as a plain [Row], so an RTL
/// locale mirrors it and slide 1 lights up the right-most dot, as designed.
class SplashIndicator extends StatelessWidget {
  const SplashIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  static const double _dotSize = 7;
  static const double _activeWidth = 18;

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
          width: isActive ? _activeWidth : _dotSize,
          height: _dotSize,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.secondary
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(_dotSize),
          ),
        );
      }),
    );
  }
}
