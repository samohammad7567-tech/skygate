import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/payment_assets.dart';

/// "نوع المبلغ المحول :" — the blue caption over each block of the payment
/// sheet, with the grey line of guidance the design puts under some of them.
class PaymentFieldLabel extends StatelessWidget {
  const PaymentFieldLabel({super.key, required this.labelKey, this.hintKey});

  final String labelKey;
  final String? hintKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${labelKey.tr()} :',
          textAlign: TextAlign.end,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        if (hintKey != null) ...[
          const Gap(4),
          Text(
            hintKey!.tr(),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }
}

/// The blue-bordered note the sheet opens with: "يرجى تعبئة بيانات التحويل و
/// رفع صورة الوصل ليتم مراجعة الدفع و تأكيده".
class PaymentNoteCard extends StatelessWidget {
  const PaymentNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          AppImage(
            PaymentAssets.info,
            height: 22,
            width: 22,
            color: theme.colorScheme.primary,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              'payment_sheet_note'.tr(),
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
