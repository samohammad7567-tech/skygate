import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PassportScanTrigger extends StatelessWidget {
  const PassportScanTrigger({
    super.key,
    required this.caption,
    required this.onTap,
    this.captionFirst = true,
  });

  final String caption;
  final VoidCallback onTap;
  final bool captionFirst;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = Text(
      caption,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 14.fs,
      ),
    );

    final frame = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.s),
      child: Padding(
        padding: EdgeInsets.all(4.s),
        child: AppImage(ProfileAssets.scan, height: 82.s),
      ),
    );

    return Column(
      children: captionFirst
          ? [text, Gap(14.s), frame]
          : [frame, Gap(14.s), text],
    );
  }
}
