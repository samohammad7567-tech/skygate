import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';
import 'package:skygate/features/booking/widgets/payment_installment_tile.dart';

class PaymentScheduleCard extends StatelessWidget {
  const PaymentScheduleCard({super.key, required this.installments});

  final List<BookingInstallmentModel> installments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14.s, 12.s, 14.s, 12.s),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13.s)),
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
                Gap(10.s),
                AppImage(
                  JourneyAssets.calendar,
                  height: 22.s,
                  width: 22.s,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < installments.length; i++) ...[
                  PaymentInstallmentTile(installment: installments[i]),
                  if (i < installments.length - 1) Gap(10.s),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
