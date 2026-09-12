import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
  final Widget? child;

  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.s),
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
          Gap(6.s),
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
        padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 6.s),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.s),
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
