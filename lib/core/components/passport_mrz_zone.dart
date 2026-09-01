import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/placeholder_bar.dart';

/// Dashed "منطقة الشيفرة (MRZ)" block at the foot of the mocked passport page.
class PassportMrzZone extends StatelessWidget {
  const PassportMrzZone({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashedBox(
      fillColor: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlaceholderBar(widthFactor: 1),
          const Gap(9),
          const PlaceholderBar(widthFactor: 0.9),
          const Gap(9),
          const PlaceholderBar(widthFactor: 0.75),
          const Gap(12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'mrz_zone'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
