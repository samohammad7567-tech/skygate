import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/payments/models/payment_installment_model.dart';
import 'package:skygate/features/payments/widgets/payment_timeline_rail.dart';

/// One row of "جدول المدفوعات": the rail dot on the reading side, then the
/// instalment number over its amount, share, due date and standing.
class PaymentTimelineTile extends StatelessWidget {
  const PaymentTimelineTile({
    super.key,
    required this.installment,
    required this.isFirst,
    required this.isLast,
  });

  final PaymentInstallmentModel installment;

  /// Trims the connector so the rail starts and ends on a dot.
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = installment.status.accent(theme);

    // A settled or still-distant instalment is stated in the calm body colour;
    // only the one actually due is called out in orange.
    final isDue = installment.status == InstallmentStatus.due;
    final detail = isDue
        ? theme.colorScheme.secondary
        : theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentTimelineRail(
            color: accent,
            isFirst: isFirst,
            isLast: isLast,
            isDue: isDue,
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'installment_number'.tr(
                      args: ['${installment.number ?? 0}'],
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Gap(6),
                  _Line(
                    leading: installment.percentage == null
                        ? ''
                        : '${installment.percentage}%',
                    trailing: installment.formattedAmount,
                    trailingColor: theme.colorScheme.primary,
                  ),
                  const Gap(6),
                  _Line(
                    leading: installment.status.labelKey.tr(),
                    leadingColor: detail,
                    trailing: AppFormat.shortDate(
                      installment.dueAt,
                      context.locale.languageCode,
                    ),
                    trailingColor: detail,
                    trailingIcon: Icons.calendar_month_outlined,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A value on the reading side with a secondary figure opposite it.
class _Line extends StatelessWidget {
  const _Line({
    required this.leading,
    required this.trailing,
    this.leadingColor,
    this.trailingColor,
    this.trailingIcon,
  });

  final String leading;
  final String trailing;
  final Color? leadingColor;
  final Color? trailingColor;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            leading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(color: leadingColor),
          ),
        ),
        const Gap(8),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  trailing,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: trailingColor,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const Gap(6),
                Icon(trailingIcon, size: 14, color: trailingColor),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
