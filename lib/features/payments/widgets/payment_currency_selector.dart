import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/features/payments/models/payment_currency.dart';
import 'package:skygate/features/payments/widgets/payment_radio.dart';

/// "نوع المبلغ المحول" — the two currencies a transfer can have been made in,
/// side by side, with the picked one tinted.
class PaymentCurrencySelector extends StatelessWidget {
  const PaymentCurrencySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentCurrency selected;
  final ValueChanged<PaymentCurrency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final currency in PaymentCurrency.values) ...[
          Expanded(
            child: _Option(
              currency: currency,
              isSelected: currency == selected,
              onTap: () => onChanged(currency),
            ),
          ),
          if (currency != PaymentCurrency.values.last) const Gap(12),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentCurrency currency;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(14);

    return Material(
      color: isSelected
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              PaymentRadio(isSelected: isSelected),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currency.labelKey.tr(),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      currency.code,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.18)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: AppImage(
                  currency.icon,
                  height: 18,
                  width: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
