import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/payment_installment_model.dart';
import 'package:skygate/features/payments/widgets/payment_timeline_tile.dart';

class PaymentTimelineCard extends StatelessWidget {
  const PaymentTimelineCard({super.key, required this.installments});

  final List<PaymentInstallmentModel> installments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.s, 14.s, 16.s, 8.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
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
          Gap(4.s),
          for (var i = 0; i < installments.length; i++) ...[
            PaymentTimelineTile(
              installment: installments[i],
              isFirst: i == 0,
              isLast: i == installments.length - 1,
            ),
            if (i < installments.length - 1)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 40.s),
                child: Divider(height: 1.s),
              ),
          ],
        ],
      ),
    );
  }
}
