import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Rule — "أو" — rule, the separator between the primary and secondary
/// action on the auth and booking cards.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = Expanded(
      child: Container(height: 1, color: theme.colorScheme.primary),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
