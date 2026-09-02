import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';

/// "مرفوضة / مؤكدة / قيد المراجعة" pill on a transaction card.
///
/// Each standing keeps its own tint across the whole flow, so a transfer is
/// recognisable at a glance without reading the label.
class TransactionStatusChip extends StatelessWidget {
  const TransactionStatusChip({super.key, required this.status});

  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.labelKey.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: status.foreground),
      ),
    );
  }
}
