import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/profile_assets.dart';

class PassportScanBanner extends StatelessWidget {
  const PassportScanBanner({super.key, this.succeeded = true});
  final bool succeeded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surface = succeeded ? AppColors.successSurface : _errorSurface;
    final border = succeeded ? AppColors.successBorder : _errorBorder;
    final accent = succeeded ? AppColors.success : AppColors.error;
    final titleColor = succeeded ? AppColors.successText : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (succeeded ? 'scan_success_title' : 'scan_failed_title').tr(),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: titleColor,
                  ),
                ),
                const Gap(2),
                Text(
                  (succeeded ? 'scan_success_desc' : 'scan_failed_desc').tr(),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall?.copyWith(color: accent),
                ),
              ],
            ),
          ),
          const Gap(12),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: AppImage(
                succeeded
                    ? ProfileAssets.scanSucceeded
                    : ProfileAssets.scanFailed,
                height: succeeded ? 14 : 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const Color _errorSurface = Color(0xFFFDECEC);
const Color _errorBorder = Color(0xFFF5C2C2);
