import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';

class AppTitleHeader extends StatelessWidget {
  const AppTitleHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
    this.onMenuTap,
  });
  final String? title;
  final bool showBack;
  final VoidCallback? onBack;

  /// Set on a tab root so the drawer handle sits where every other tab puts
  /// it. The pushed auth and booking screens leave it null.
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        // The corner chips are AppMenuButton.size tall and sit positioned, so
        // they do not grow the stack. Without a floor it shrinks to the title
        // text, which differs per screen — the chips then overflow (clipped by
        // the stack) and land at a different height on every tab.
        constraints: const BoxConstraints(minHeight: AppMenuButton.size),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppBackButton.size + 8,
              ),
              child: title == null
                  ? const _LogoCard()
                  : Text(
                      title!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall,
                    ),
            ),
            // Start corner — the right in Arabic — carries the way back, and
            // the end corner the drawer handle. See [AppBackButton].
            if (showBack)
              PositionedDirectional(
                start: 0,
                child: AppBackButton(onTap: onBack),
              ),
            if (onMenuTap != null)
              PositionedDirectional(
                end: 0,
                child: AppMenuButton(onTap: onMenuTap),
              ),
          ],
        ),
      ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const AppImage(AuthAssets.logo, height: 48),
    );
  }
}
