import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GroupAddTravelerButton extends StatelessWidget {
  const GroupAddTravelerButton({
    super.key,
    required this.onTap,
    required this.filled,
    this.labelKey = 'add_traveler',
  });

  final VoidCallback onTap;
  final bool filled;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = filled
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primary;

    final label = Text(
      labelKey.tr(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelLarge?.copyWith(color: foreground),
    );
    final icon = Icon(Icons.add_circle_outline, size: 20, color: foreground);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    );
    const padding = EdgeInsets.symmetric(horizontal: 22, vertical: 12);

    return filled
        ? ElevatedButton.icon(
            onPressed: onTap,
            icon: icon,
            label: label,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              elevation: 0,
              padding: padding,
              shape: shape,
            ),
          )
        : OutlinedButton.icon(
            onPressed: onTap,
            icon: icon,
            label: label,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.primary),
              padding: padding,
              shape: shape,
            ),
          );
  }
}
