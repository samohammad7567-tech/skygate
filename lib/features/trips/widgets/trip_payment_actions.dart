import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';
import 'package:skygate/features/trips/widgets/trip_booking_summary.dart';

/// "المبلغ المتبقي" beside the two actions a booking awaiting payment offers.
class TripPaymentActions extends StatelessWidget {
  const TripPaymentActions({
    super.key,
    required this.booking,
    required this.onDetails,
    required this.onPay,
  });

  final BookingTripModel booking;
  final VoidCallback onDetails;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onDetails,
            style: OutlinedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(color: theme.colorScheme.primary),
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'view_details'.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          child: CustomButton(
            label: 'complete_payment'.tr(),
            height: 42,
            backgroundColor: theme.colorScheme.secondary,
            onPressed: onPay,
          ),
        ),
        const Gap(10),
        TripRemainingAmount(booking: booking),
      ],
    );
  }
}
