import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';

class BookingSelectableCard extends StatelessWidget {
  const BookingSelectableCard({
    super.key,
    required this.child,
    required this.isSelected,
    required this.onTap,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(14.s);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BookingRadio extends StatelessWidget {
  const BookingRadio({super.key, required this.isSelected, this.size});

  final bool isSelected;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return Container(
      height: (size ?? 24.s),
      width: (size ?? 24.s),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.s),
      ),
      child: isSelected
          ? Container(
              height: (size ?? 24.s) / 2,
              width: (size ?? 24.s) / 2,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
