import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppStepperButton extends StatelessWidget {
  const AppStepperButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = onTap == null
        ? theme.colorScheme.outlineVariant
        : theme.colorScheme.primary;

    return InkResponse(
      onTap: onTap,
      radius: 20.s,
      child: Container(
        height: 26.s,
        width: 26.s,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16.s, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
