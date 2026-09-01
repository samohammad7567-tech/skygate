import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Small caption above a field, used on "تأكيد بيانات الجواز" where every row
/// is labelled rather than relying on a placeholder.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const Gap(6),
        child,
      ],
    );
  }
}
