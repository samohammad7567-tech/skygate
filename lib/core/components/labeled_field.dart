import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
        Gap(6.s),
        child,
      ],
    );
  }
}
