import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key, this.onTap});

  final VoidCallback? onTap;
  static const double size = 40;
  static const double glyphSize = 20;

  @override
  Widget build(BuildContext context) => AppCircleIconButton(
    asset: HomeAssets.menu,
    tooltip: 'menu'.tr(),
    size: size.s,
    glyphSize: glyphSize.s,
    onTap: onTap,
  );
}
