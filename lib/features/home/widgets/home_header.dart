import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/constants/app_assets.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.onMenuTap,
    this.onNotificationsTap,
    this.unreadCount = 0,
  });

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;
  final int unreadCount;
  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height.s,
      padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 8.s),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.s)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12.s,
            offset: Offset(0, 4.s),
          ),
        ],
      ),
      child: Row(
        children: [
          _HeaderIcon(
            asset: HomeAssets.notifications,
            tooltip: 'notifications'.tr(),
            onTap: onNotificationsTap,
            badge: unreadCount,
          ),
          Expanded(
            child: AppImage(AppAssets.logo, height: 44.s, fit: BoxFit.contain),
          ),
          AppMenuButton(onTap: onMenuTap),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.asset,
    required this.tooltip,
    this.onTap,
    this.badge = 0,
  });

  final String asset;
  final String tooltip;
  final VoidCallback? onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        AppCircleIconButton(
          asset: asset,
          tooltip: tooltip,
          size: AppMenuButton.size.s,
          glyphSize: AppMenuButton.glyphSize.s,
          onTap: onTap,
        ),
        if (badge > 0)
          PositionedDirectional(
            top: 2.s,
            end: 2.s,
            child: IgnorePointer(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.s, vertical: 1.s),
                constraints: BoxConstraints(minWidth: 18.s),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20.s),
                ),
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 10.fs,
                    height: 1.2.s,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
