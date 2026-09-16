import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: AppMenuButton.size.s),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppBackButton.size.s + 8.s,
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
      padding: EdgeInsets.symmetric(horizontal: 44.s, vertical: 10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.s),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 18.s,
            offset: Offset(0, 6.s),
          ),
        ],
      ),
      child: AppImage(AuthAssets.logo, height: 48.s),
    );
  }
}
