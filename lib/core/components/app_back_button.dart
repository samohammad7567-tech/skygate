import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    return AppCircleIconButton(
      asset: AuthAssets.arrowBack,
      size: size,
      onTap: onTap ?? () => NaivgatorHelper.popNavigation(context),
    );
  }
}
