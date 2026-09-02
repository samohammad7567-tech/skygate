import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/features/payments/models/payment_installment_model.dart';
import 'package:skygate/features/payments/widgets/payment_timeline_tile.dart';

/// "جدول المدفوعات" — every instalment of the booking strung along one rail,
/// in the order they fall due.
class PaymentTimelineCard extends StatelessWidget {
  const PaymentTimelineCard({super.key, required this.installments});

  final List<PaymentInstallmentModel> installments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'payment_timeline'.tr(),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const Gap(4),
          for (var i = 0; i < installments.length; i++) ...[
            PaymentTimelineTile(
              installment: installments[i],
              isFirst: i == 0,
              isLast: i == installments.length - 1,
            ),
            if (i < installments.length - 1)
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 40),
                child: Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }
}
