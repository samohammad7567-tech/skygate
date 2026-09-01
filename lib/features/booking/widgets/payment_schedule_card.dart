import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';
import 'package:skygate/features/booking/widgets/payment_installment_tile.dart';

/// "جدول دفعات الرحلة" — one tile per instalment, in the order they fall due.
class PaymentScheduleCard extends StatelessWidget {
  const PaymentScheduleCard({super.key, required this.installments});

  final List<BookingInstallmentModel> installments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'payment_schedule'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const Gap(10),
                AppImage(
                  JourneyAssets.calendar,
                  height: 22,
                  width: 22,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < installments.length; i++) ...[
                  PaymentInstallmentTile(installment: installments[i]),
                  if (i < installments.length - 1) const Gap(10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
