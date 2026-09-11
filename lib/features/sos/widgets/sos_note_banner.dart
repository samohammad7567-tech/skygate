import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/sos_assets.dart';

class SosNoteBanner extends StatelessWidget {
  const SosNoteBanner({
    super.key,
    required this.messageKey,
    this.titleKey,
    this.icon,
  });
  final String messageKey;
  final String? titleKey;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heading = titleKey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (heading != null) ...[
                  Text(
                    heading.tr(),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Gap(4),
                ],
                Text(
                  messageKey.tr(),
                  textAlign: TextAlign.end,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          AppImage(
            icon ?? SosAssets.quickSos,
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
