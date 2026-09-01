import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

/// Round white back chip shown at the top of every screen past the landing
/// card. Falls back to popping the route when no [onTap] is given.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.15),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap ?? () => NaivgatorHelper.popNavigation(context),
        child: SizedBox(
          height: size,
          width: size,
          child: Center(
            child: AppImage(
              AuthAssets.arrowBack,
              height: 18,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
