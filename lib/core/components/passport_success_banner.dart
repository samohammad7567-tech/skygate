import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/auth_assets.dart';

/// Green "تم مسح ومطابقة البيانات بنجاح" strip above the confirmation form.
class PassportSuccessBanner extends StatelessWidget {
  const PassportSuccessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'scan_success_title'.tr(),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.successText,
                  ),
                ),
                const Gap(2),
                Text(
                  'scan_success_desc'.tr(),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: AppImage(
                AuthAssets.correctIcon,
                height: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
