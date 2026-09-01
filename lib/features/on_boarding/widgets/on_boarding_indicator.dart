import 'package:flutter/material.dart';

/// Page dots that sit inside the copy card.
///
/// The active page is a wide pill in the accent colour; the rest are small
/// grey dots. Laid out as a plain [Row], so an RTL locale mirrors it and the
/// first page lights up the right-most dot, matching the design.
class OnBoardingIndicator extends StatelessWidget {
  const OnBoardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  static const double _dotSize = 8;
  static const double _activeWidth = 20;

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
                : theme.colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(_dotSize),
          ),
        );
      }),
    );
  }
}
