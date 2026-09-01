import 'package:flutter/material.dart';
import 'package:skygate/core/components/custom_button.dart';

/// White strip pinned under the body holding the screen's primary action.
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
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: CustomButton(
            label: label,
            onPressed: onPressed,
            height: 48,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
