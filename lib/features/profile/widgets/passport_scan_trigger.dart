import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/profile_assets.dart';

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
        fontSize: 14,
      ),
    );

    final frame = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: AppImage(ProfileAssets.scan, height: 82),
      ),
    );

    return Column(
      children: captionFirst
          ? [text, const Gap(14), frame]
          : [frame, const Gap(14), text],
    );
  }
}
