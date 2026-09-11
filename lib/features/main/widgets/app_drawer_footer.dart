import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/drawer_assets.dart';

class AppDrawerFooter extends StatelessWidget {
  const AppDrawerFooter({
    super.key,
    required this.onLogout,
    this.isLoggingOut = false,
  });

  final VoidCallback onLogout;
  final bool isLoggingOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: AppColors.accentSoft, height: 1),
          const Gap(16),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: OutlinedButton(
              // Disabled while the call is out, so a second tap cannot start a
              // second logout on top of the first.
              onPressed: isLoggingOut ? null : onLogout,
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(color: foreground),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoggingOut
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: foreground,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'logout'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                        const Gap(10),
                        AppImage(
                          DrawerAssets.logout,
                          width: 20,
                          height: 20,
                          color: foreground,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
