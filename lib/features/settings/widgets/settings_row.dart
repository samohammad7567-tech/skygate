import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';

/// The shared left-hand half of every settings row: the glyph on its tinted
/// plate, the title, and the line of explanation under it.
///
/// [SettingsSwitchRow] and [SettingsTile] both wrap this and differ only in
/// what they hang on the end edge.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.color,
  });

  final String icon;
  final String title;
  final String? subtitle;

  /// The switch, the chevron, or the value the row carries.
  final Widget? trailing;

  final VoidCallback? onTap;

  /// Tints the glyph and the title. Left unset both take the brand blue.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: AppImage(icon, height: 20, color: accent)),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(color: accent),
                  ),
                  if (subtitle != null) ...[
                    const Gap(3),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const Gap(10), trailing!],
          ],
        ),
      ),
    );
  }
}
