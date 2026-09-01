import 'package:flutter/material.dart';

/// Blue section heading inside a form card ("المعلومات الشخصية :",
/// "معلومات جواز السفر:", "تأكد من صحة البيانات أدناه:").
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
          const SizedBox(height: 4),
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
