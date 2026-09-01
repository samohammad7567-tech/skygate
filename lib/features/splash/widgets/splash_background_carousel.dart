import 'package:flutter/material.dart';

/// Full-bleed photo slideshow behind the entry panel.
///
/// The page count is unbounded on purpose: the builder resolves the photo with
/// a modulo, so the timer can keep calling "next page" forever and the last
/// photo rolls over to the first without rewinding through the set.
class SplashBackgroundCarousel extends StatelessWidget {
  const SplashBackgroundCarousel({
    super.key,
    required this.controller,
    required this.backgroundAt,
    required this.onPageChanged,
  });

  final PageController controller;

  /// Resolves a raw page index to a bundled photo.
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
