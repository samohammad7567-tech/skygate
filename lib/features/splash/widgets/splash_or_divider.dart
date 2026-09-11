import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SplashOrDivider extends StatelessWidget {
  const SplashOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: Colors.white.withValues(alpha: 0.55)),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or'.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
        line,
      ],
    );
  }
}
