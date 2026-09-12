import 'package:flutter/material.dart';
import 'package:skygate/features/settings/widgets/settings_row.dart';

/// A preference the reader turns on or off in place.
class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      // The whole row is the target, which is a wider one than the switch.
      onTap: () => onChanged(!value),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: theme.colorScheme.onPrimary,
        activeTrackColor: theme.colorScheme.primary,
      ),
    );
  }
}
