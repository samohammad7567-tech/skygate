import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class SplashOrDivider extends StatelessWidget {
  const SplashOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(
        height: 1.s,
        color: Colors.white.withValues(alpha: 0.55),
      ),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.s),
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
