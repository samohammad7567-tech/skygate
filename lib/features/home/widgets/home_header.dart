import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_assets.dart';
import 'package:skygate/core/constants/home_assets.dart';

/// Bar pinned above the hero: menu on the start side, the Sky Gate lockup
/// centred, notifications on the end side.
///
/// It shares the page background and is separated from the photo below it by
/// its rounded bottom corners and a soft shadow, so it has to be painted on
/// top of the scrolling body rather than as its first item.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.onMenuTap, this.onNotificationsTap});

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;

  /// Fixed so the scrolling body underneath can reserve exactly this much room.
  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          _HeaderIcon(
            asset: HomeAssets.menu,
            tooltip: 'menu'.tr(),
            onTap: onMenuTap,
          ),
          Expanded(
            child: AppImage(AppAssets.logo, height: 44, fit: BoxFit.contain),
          ),
          _HeaderIcon(
            asset: HomeAssets.notifications,
            tooltip: 'notifications'.tr(),
            onTap: onNotificationsTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.asset, required this.tooltip, this.onTap});

  final String asset;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: EdgeInsets.zero,
      icon: AppImage(
        asset,
        width: 24,
        height: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
