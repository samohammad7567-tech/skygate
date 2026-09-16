import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';
import 'package:skygate/features/payments/widgets/transaction_status_chip.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    required this.position,
  });

  final FinancialTransactionModel transaction;
  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;
    final createdAt = transaction.createdAt;

    return Container(
      padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 14.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TransactionStatusChip(status: transaction.status),
              Gap(10.s),
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
          Gap(10.s),
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
              Gap(10.s),
              Expanded(
                child: Text(
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
          Gap(8.s),
          _Stamp(
            value: AppFormat.shortDate(createdAt, locale),
            icon: Icons.calendar_month_outlined,
          ),
          Gap(4.s),
          _Stamp(
            value: AppFormat.time(createdAt, locale),
            icon: Icons.schedule,
          ),
          if (transaction.rejectionReason != null) ...[
            Gap(10.s),
            Divider(height: 1.s),
            Gap(10.s),
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
        Gap(6.s),
        Icon(icon, size: 14.s, color: color),
      ],
    );
  }
}
