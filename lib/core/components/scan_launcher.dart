import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ScanLauncher extends StatelessWidget {
  const ScanLauncher({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'you_can_use_camera'.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20.fs),
        ),
        Gap(14.s),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.s),
          child: Padding(
            padding: EdgeInsets.all(4.s),
            child: AppImage(AuthAssets.camera, height: 82.s),
          ),
        ),
      ],
    );
  }
}
