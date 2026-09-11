import 'package:flutter/material.dart';

/// The round `+` / `−` button on either side of a counter.
///
/// Greys out on its own when [onTap] is null, which is how both counters say
/// "you are at the limit" — the room counter of "توزيع الغرف" and the
/// traveller stepper of "تقديم طلب رحلة خاصة".
class AppStepperButton extends StatelessWidget {
  const AppStepperButton({super.key, required this.icon, required this.onTap});

  final IconData icon;

  /// Null disables the button and drops it to the disabled tint.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = onTap == null
        ? theme.colorScheme.outlineVariant
        : theme.colorScheme.primary;

    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Container(
        height: 26,
        width: 26,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
