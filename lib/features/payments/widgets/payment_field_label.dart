import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
          Gap(4.s),
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

class PaymentNoteCard extends StatelessWidget {
  const PaymentNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 12.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          AppImage(
            PaymentAssets.info,
            height: 22.s,
            width: 22.s,
            color: theme.colorScheme.primary,
          ),
          Gap(12.s),
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
