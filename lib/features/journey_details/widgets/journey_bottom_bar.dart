import 'package:flutter/material.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/app_scale.dart';

class JourneyBottomBar extends StatelessWidget {
  const JourneyBottomBar({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.s, 14.s, 20.s, 14.s),
          child: CustomButton(
            label: label,
            onPressed: onPressed,
            height: 48.s,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
