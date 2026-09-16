import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class VipRibbon extends StatelessWidget {
  const VipRibbon({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: (width ?? 32.s),
      height: (height ?? 46.s),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AppImage(
            HomeAssets.vipPennant,
            width: (width ?? 32.s),
            height: (height ?? 46.s),
          ),
          Padding(
            padding: EdgeInsets.only(top: (height ?? 46.s) * 0.26),
            child: Text(
              'vip'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontSize: 12.fs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
