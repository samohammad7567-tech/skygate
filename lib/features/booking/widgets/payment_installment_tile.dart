import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';

/// One row of "جدول دفعات الرحلة": the amount, the due copy, then the round
/// percentage badge.
class PaymentInstallmentTile extends StatelessWidget {
  const PaymentInstallmentTile({super.key, required this.installment});

  final BookingInstallmentModel installment;

  /// A relative deadline ("خلال 24 ساعة") is the urgent one the design tints
  /// orange; a fixed date stays on the calm blue tile.
  bool get _isUrgent => installment.dueWithinHours != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _isUrgent
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;
    final amount = installment.amount;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isUrgent
            ? AppColors.accentSurface.withValues(alpha: 0.35)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            amount == null ? '—' : '$amount${installment.currency ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(color: accent),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'installment_number'.tr(args: ['${installment.number ?? 0}']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const Gap(2),
                Text(
                  'installment_due_by'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const Gap(2),
                _Deadline(installment: installment, accent: accent),
              ],
            ),
          ),
          const Gap(10),
          _PercentBadge(percentage: installment.percentage, color: accent),
        ],
      ),
    );
  }
}

/// "خلال 24 ساعة" or "30 أغسطس 2026", with the matching glyph after it.
class _Deadline extends StatelessWidget {
  const _Deadline({required this.installment, required this.accent});

  final BookingInstallmentModel installment;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hours = installment.dueWithinHours;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            hours != null
                ? 'installment_within_hours'.tr(args: ['$hours'])
                : AppFormat.shortDate(
                    installment.dueAt,
                    context.locale.languageCode,
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: accent),
          ),
        ),
        const Gap(6),
        Icon(
          hours != null ? Icons.schedule : Icons.calendar_month_outlined,
          size: 14,
          color: accent,
        ),
      ],
    );
  }
}

/// Filled round badge printing the share of the total this instalment settles.
class _PercentBadge extends StatelessWidget {
  const _PercentBadge({required this.percentage, required this.color});

  final int? percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        '${percentage ?? 0}%',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
