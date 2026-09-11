import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/constants/home_assets.dart';

/// The drawer handle. Every screen that opens [AppDrawer] renders it through
/// this widget so the chip keeps one shape and one size across the tabs — the
/// icon must not move or resize as the reader swaps tabs underneath it.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key, this.onTap});

  final VoidCallback? onTap;

  /// Matches `AppBackButton.size`, so the two corners of a header balance.
  static const double size = 40;
  static const double glyphSize = 20;

  @override
  Widget build(BuildContext context) => AppCircleIconButton(
    asset: HomeAssets.menu,
    tooltip: 'menu'.tr(),
    size: size,
    glyphSize: glyphSize,
    onTap: onTap,
  );
}
