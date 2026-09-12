import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppDrawerSectionLabel extends StatelessWidget {
  const AppDrawerSectionLabel({super.key, required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.s, 20.s, 20.s, 10.s),
      child: Row(
        children: [
          Text(
            titleKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.accent,
            ),
          ),
          Gap(10.s),
          Expanded(
            child: Divider(color: AppColors.accentSoft, height: 1.s),
          ),
        ],
      ),
    );
  }
}
