import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class FormSectionTitle extends StatelessWidget {
  const FormSectionTitle({super.key, required this.text, this.subtitle});

  final String text;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(text, textAlign: TextAlign.end, style: theme.textTheme.titleLarge),
        if (subtitle != null) ...[
          SizedBox(height: 4.s),
          Text(
            subtitle!,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
