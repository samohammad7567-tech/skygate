import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppPanel extends StatelessWidget {
  const AppPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.fromLTRB(20.s, 24.s, 20.s, 24.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.s),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 24.s,
            offset: Offset(0, 8.s),
          ),
        ],
      ),
      child: child,
    );
  }
}
