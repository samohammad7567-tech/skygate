import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/auth_assets.dart';

/// "يمكنك استخدام الكاميرا" prompt plus the framed scan trigger, shown on the
/// personal-info step and again on the passport confirmation card.
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
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
        ),
        const Gap(14),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: AppImage(AuthAssets.imageScanner, height: 82),
          ),
        ),
      ],
    );
  }
}
