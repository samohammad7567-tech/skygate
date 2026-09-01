import 'package:flutter/material.dart';

/// The shell every "pick one" card in the wizard sits in: a rounded card that
/// takes the primary border and tint once it is ticked.
///
/// The radio itself is drawn by the card's own header, because the design puts
/// it in a different place on each step.
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
    final radius = BorderRadius.circular(14);

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

/// The ringed dot the wizard uses instead of a Material `Radio`, so it keeps
/// the design's proportions on every card.
class BookingRadio extends StatelessWidget {
  const BookingRadio({super.key, required this.isSelected, this.size = 24});

  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: isSelected
          ? Container(
              height: size / 2,
              width: size / 2,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
