import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';
import 'package:skygate/features/payments/widgets/transaction_status_chip.dart';

/// One card of "المعاملات المالية": who transferred what, when, where it
/// stands, and — when it was turned down — why.
class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    required this.position,
  });

  final FinancialTransactionModel transaction;

  /// 1-based place in the list, printed as "المعاملة #1".
  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final createdAt = transaction.createdAt;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TransactionStatusChip(status: transaction.status),
              const Gap(10),
              Expanded(
                child: Text(
                  'transaction_number'.tr(args: ['$position']),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Text(
                transaction.formattedAmount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  // `FinancialTransactionResource` publishes no payer, so the
                  // reference number stands in until it does.
                  transaction.payerName ?? transaction.referenceNumber ?? '—',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          _Stamp(
            value: AppFormat.shortDate(createdAt, locale),
            icon: Icons.calendar_month_outlined,
          ),
          const Gap(4),
          _Stamp(
            value: AppFormat.time(createdAt, locale),
            icon: Icons.schedule,
          ),
          if (transaction.rejectionReason != null) ...[
            const Gap(10),
            const Divider(height: 1),
            const Gap(10),
            Text(
              'rejection_reason'.tr(args: [transaction.rejectionReason!]),
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A date or time with its glyph after it, on the reading side.
class _Stamp extends StatelessWidget {
  const _Stamp({required this.value, required this.icon});

  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
        const Gap(6),
        Icon(icon, size: 14, color: color),
      ],
    );
  }
}
