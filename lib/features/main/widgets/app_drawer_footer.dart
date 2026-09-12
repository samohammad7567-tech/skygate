import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/drawer_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
      padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 20.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: AppColors.accentSoft, height: 1.s),
          Gap(16.s),
          SizedBox(
            height: 48.s,
            width: double.infinity,
            child: OutlinedButton(
              // Disabled while the call is out, so a second tap cannot start a
              // second logout on top of the first.
              onPressed: isLoggingOut ? null : onLogout,
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(color: foreground),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.s),
                ),
              ),
              child: isLoggingOut
                  ? SizedBox(
                      height: 18.s,
                      width: 18.s,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.s,
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
                        Gap(10.s),
                        AppImage(
                          DrawerAssets.logout,
                          width: 20.s,
                          height: 20.s,
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
