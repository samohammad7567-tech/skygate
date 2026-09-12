import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PaymentRadio extends StatelessWidget {
  const PaymentRadio({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.45);

    return Container(
      height: 22.s,
      width: 22.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.s),
      ),
      child: isSelected
          ? Container(
              height: 11.s,
              width: 11.s,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}
