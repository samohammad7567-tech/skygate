import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.dotSize,
    this.activeWidth,
    this.activeColor,
    this.inactiveColor,
  });

  final int count;
  final int currentIndex;
  final double? dotSize;
  final double? activeWidth;
  final Color? activeColor;
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
          width: isActive ? (activeWidth ?? 20.s) : (dotSize ?? 8.s),
          height: (dotSize ?? 8.s),
          margin: EdgeInsets.symmetric(horizontal: 3.s),
          decoration: BoxDecoration(
            color: isActive
                ? (activeColor ?? theme.colorScheme.secondary)
                : (inactiveColor ?? theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular((dotSize ?? 8.s)),
          ),
        );
      }),
    );
  }
}
