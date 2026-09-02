import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/payments/models/booking_payment_model.dart';
import 'package:skygate/features/payments/widgets/payment_ring.dart';

/// "ملخص المدفوعات" — the ring beside the total, the paid and the outstanding
/// figure. Heads both "المدفوعات" and "المعاملات المالية".
class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.payment});

  final BookingPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'payment_summary'.tr(),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const Gap(10),
          Row(
            children: [
              PaymentRing(
                ratio: payment.paidRatio,
                percent: payment.paidPercent,
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Row(
                      labelKey: 'payment_total_amount',
                      value: payment.amountLabel(payment.total),
                    ),
                    const Divider(height: 1),
                    _Row(
                      labelKey: 'payment_paid',
                      value: payment.amountLabel(payment.paid ?? 0),
                    ),
                    const Divider(height: 1),
                    _Row(
                      labelKey: 'payment_remaining',
                      value: payment.amountLabel(payment.remaining),
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One figure of the summary: the caption on the reading side, the amount
/// opposite it.
class _Row extends StatelessWidget {
  const _Row({required this.labelKey, required this.value, this.color});

  final String labelKey;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(color: accent),
            ),
          ),
          const Gap(8),
          Flexible(
            child: Text(
              labelKey.tr(),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: accent),
            ),
          ),
        ],
      ),
    );
  }
}
