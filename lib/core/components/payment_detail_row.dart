import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Grey caption over its value — the shape every "تفاصيل الحجز" row takes.
class PaymentDetailRow extends StatelessWidget {
  const PaymentDetailRow({
    super.key,
    required this.labelKey,
    this.value,
    this.child,
    this.valueColor,
  });

  final String labelKey;
  final String? value;

  /// Rendered instead of [value] — used for the booking-type chip.
  final Widget? child;

  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const Gap(6),
          child ??
              Text(
                value ?? '—',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(color: valueColor),
              ),
        ],
      ),
    );
  }
}

/// Outlined pill naming the booking type on the summary's "النوع" row.
///
/// Orange by default, as the wizard prints it; "تفاصيل الحجز" passes the blue
/// the design uses there for a group booking.
class BookingTypeChip extends StatelessWidget {
  const BookingTypeChip({super.key, required this.labelKey, this.color});

  final String labelKey;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.secondary;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent),
        ),
        child: Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
