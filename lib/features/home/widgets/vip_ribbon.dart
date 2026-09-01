import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/home_assets.dart';

/// Orange pennant hanging from the top of the custom-trip artwork.
///
/// The pennant shape ships as an export; only the label is drawn on top of it.
class VipRibbon extends StatelessWidget {
  const VipRibbon({super.key, this.width = 32, this.height = 46});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AppImage(HomeAssets.vipPennant, width: width, height: height),
          Padding(
            padding: EdgeInsets.only(top: height * 0.26),
            child: Text(
              'vip'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
