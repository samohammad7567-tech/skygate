import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/auth_assets.dart';

/// Top strip of a full-bleed screen: either the floating Sky Gate logo card or
/// a plain page title, with the back chip pinned to the end side.
///
/// The back chip sits on the end side because the Arabic mockups place it on
/// the left; using a directional alignment keeps it sensible under LTR too.
class AppTitleHeader extends StatelessWidget {
  const AppTitleHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
  });

  /// When null the Sky Gate logo card is shown instead of a text title.
  final String? title;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
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
          if (showBack)
            PositionedDirectional(end: 0, child: AppBackButton(onTap: onBack)),
        ],
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
