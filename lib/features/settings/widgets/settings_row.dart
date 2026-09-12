import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 14.s),
        child: Row(
          children: [
            Container(
              height: 40.s,
              width: 40.s,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.s),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(color: accent),
                  ),
                  if (subtitle != null) ...[
                    Gap(3.s),
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
            if (trailing != null) ...[Gap(10.s), trailing!],
          ],
        ),
      ),
    );
  }
}
