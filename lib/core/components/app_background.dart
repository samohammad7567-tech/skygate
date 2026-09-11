import 'package:flutter/material.dart';
import 'package:skygate/core/constants/auth_assets.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AuthAssets.background,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, _, _) => ColoredBox(color: base),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                base.withValues(alpha: 0.92),
                base.withValues(alpha: 0.74),
                base.withValues(alpha: 0.90),
                base,
              ],
              stops: const [0, 0.28, 0.62, 1],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
