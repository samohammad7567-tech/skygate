import 'package:flutter/material.dart';

/// The ring the design draws instead of a Material radio — filled blue with a
/// white core when picked, a plain grey outline when not.
///
/// Both lists of options in "معلومات الدفع" — the currencies and the transfer
/// methods — use it, so the two rows of choices look identical.
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
      height: 22,
      width: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: isSelected
          ? Container(
              height: 11,
              width: 11,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}
