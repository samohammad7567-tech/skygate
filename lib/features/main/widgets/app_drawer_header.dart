import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_assets.dart';

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        // The plate runs under the status bar, so the logo — not the plate —
        // is what the inset pushes down.
        MediaQuery.paddingOf(context).top + 14,
        16,
        18,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(28),
        ),
      ),
      // The export is a single-colour lockup, so it re-tints cleanly for the
      // blue plate instead of needing a second white file.
      child: AppImage(
        AppAssets.logo,
        height: 50,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
