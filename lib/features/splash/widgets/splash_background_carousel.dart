import 'package:flutter/material.dart';

class SplashBackgroundCarousel extends StatelessWidget {
  const SplashBackgroundCarousel({
    super.key,
    required this.controller,
    required this.backgroundAt,
    required this.onPageChanged,
  });

  final PageController controller;
  final String Function(int index) backgroundAt;

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: controller,
          onPageChanged: onPageChanged,
          itemBuilder: (_, index) => Image.asset(
            backgroundAt(index),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, _, _) => ColoredBox(color: primary),
          ),
        ),
        // Blue scrim the panel copy sits on. Ignores pointers so the photo
        // underneath stays swipeable.
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  primary.withValues(alpha: 0.18),
                  primary.withValues(alpha: 0.88),
                  primary,
                ],
                stops: const [0.30, 0.48, 0.70, 0.88],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
