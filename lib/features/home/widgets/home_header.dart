import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/constants/app_assets.dart';
import 'package:skygate/core/constants/home_assets.dart';

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
      height: height,
      // 20 horizontal matches the header padding every other tab uses,
      // so the drawer handle does not shift sideways between tabs.
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        // The bar shares the page colour, so the shadow is what separates it
        // from the hero photo underneath.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AppMenuButton(onTap: onMenuTap),
          Expanded(
            child: AppImage(AppAssets.logo, height: 44, fit: BoxFit.contain),
          ),
          _HeaderIcon(
            asset: HomeAssets.notifications,
            tooltip: 'notifications'.tr(),
            onTap: onNotificationsTap,
            badge: unreadCount,
          ),
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
        // Same plate and glyph as the menu chip opposite it, so the two
        // ends of the bar read as a pair.
        AppCircleIconButton(
          asset: asset,
          tooltip: tooltip,
          size: AppMenuButton.size,
          glyphSize: AppMenuButton.glyphSize,
          onTap: onTap,
        ),
        if (badge > 0)
          PositionedDirectional(
            top: 2,
            end: 2,
            // The dot is decoration over the button it counts for; the button
            // itself is what the reader taps.
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                constraints: const BoxConstraints(minWidth: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
