import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/settings/widgets/settings_row.dart';

/// A row that opens onto something else, or simply states a value — the
/// language, the build the reader is on, the links into support and the
/// legal pages.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
  });

  final String icon;
  final String title;
  final String? subtitle;

  /// Printed on the end edge, before the chevron.
  final String? value;

  /// A row with nowhere to go — "إصدار التطبيق" — draws no chevron.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Flexible(
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
          if (onTap != null) ...[
            Gap(8.s),
            // The chevron points back along the reading direction, which is
            // what "opens onto" means in both languages.
            Transform.flip(
              flipX: Directionality.of(context) == TextDirection.rtl,
              child: AppImage(
                SettingsAssets.chevron,
                height: 16.s,
                width: 16.s,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
