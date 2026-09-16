import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/booking_payment_model.dart';
import 'package:skygate/features/payments/widgets/payment_ring.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.payment});

  final BookingPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.s, 14.s, 16.s, 16.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
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
          Gap(10.s),
          Row(
            children: [
              PaymentRing(
                ratio: payment.paidRatio,
                percent: payment.paidPercent,
              ),
              Gap(16.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Row(
                      labelKey: 'payment_total_amount',
                      value: payment.amountLabel(payment.total),
                    ),
                    Divider(height: 1.s),
                    _Row(
                      labelKey: 'payment_paid',
                      value: payment.amountLabel(payment.paid ?? 0),
                    ),
                    Divider(height: 1.s),
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
      padding: EdgeInsets.symmetric(vertical: 9.s),
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
          Gap(8.s),
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
