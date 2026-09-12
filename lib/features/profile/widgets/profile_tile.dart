import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = false,
    this.color,
  });
  final String icon;

  final String title;
  final String? subtitle;

  final VoidCallback? onTap;
  final bool showChevron;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 14.s),
        child: Row(
          children: [
            Container(
              height: 40.s,
              width: 40.s,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppImage(icon, height: 20.s, color: accent),
              ),
            ),
            Gap(12.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(color: accent),
                  ),
                  if (subtitle != null) ...[
                    Gap(3.s),
                    Text(
                      subtitle!.trim().isEmpty ? '—' : subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron) ...[
              Gap(10.s),
              AppImage(
                ProfileAssets.chevron,
                height: 13.s,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
