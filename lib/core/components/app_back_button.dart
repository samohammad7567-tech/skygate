import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';

/// The way back out of a pushed screen.
///
/// It sits in the header's **start** corner — the right in Arabic — because
/// that is where both platforms put it and where the design draws it. The
/// glyph is mirrored to match: an arrow means "backwards", which points left
/// in English and right in Arabic.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    return AppCircleIconButton(
      asset: AuthAssets.arrowBack,
      size: size.s,
      mirrorInRtl: true,
      onTap: onTap ?? () => NaivgatorHelper.popNavigation(context),
    );
  }
}
