import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';

class TransactionStatusChip extends StatelessWidget {
  const TransactionStatusChip({super.key, required this.status});

  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(
      labelKey: status.labelKey,
      background: status.background,
      foreground: status.foreground,
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 5.s),
    );
  }
}
