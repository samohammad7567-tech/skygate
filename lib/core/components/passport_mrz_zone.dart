import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/placeholder_bar.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PassportMrzZone extends StatelessWidget {
  const PassportMrzZone({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashedBox(
      fillColor: Colors.transparent,
      padding: EdgeInsets.fromLTRB(12.s, 14.s, 12.s, 12.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlaceholderBar(widthFactor: 1),
          Gap(9.s),
          const PlaceholderBar(widthFactor: 0.9),
          Gap(9.s),
          const PlaceholderBar(widthFactor: 0.75),
          Gap(12.s),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 4.s),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.s),
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
