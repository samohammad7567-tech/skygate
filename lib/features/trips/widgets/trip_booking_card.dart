import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';
import 'package:skygate/features/trips/widgets/trip_booking_summary.dart';
import 'package:skygate/features/trips/widgets/trip_payment_actions.dart';
import 'package:skygate/features/trips/widgets/trip_chips.dart';
import 'package:skygate/features/trips/widgets/trip_progress_rail.dart';

/// One card of "رحلاتي".
///
/// The head is the same on every tab; what changes underneath is the tab's own
/// business — a current booking shows how far along the trip is, one awaiting
/// payment shows what is left and how to pay it, a finished one shows neither.
class TripBookingCard extends StatelessWidget {
  const TripBookingCard({
    super.key,
    required this.booking,
    required this.onDetails,
    required this.onPay,
  });

  final BookingTripModel booking;
  final VoidCallback onDetails;

  /// "استكمال الدفع" — only reachable while something is outstanding.
  final VoidCallback onPay;

  bool get _isAwaitingPayment =>
      booking.status == BookingStatus.awaitingPayment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Photo(booking: booking),
                const Gap(10),
                Expanded(child: TripBookingSummary(booking: booking)),
              ],
            ),
          ),
          if (booking.status == BookingStatus.active &&
              booking.legs.isNotEmpty) ...[
            const Gap(14),
            TripProgressRail(
              legs: booking.legs,
              currentLeg: booking.currentLeg,
            ),
          ],
          const Gap(12),
          if (_isAwaitingPayment)
            TripPaymentActions(
              booking: booking,
              onDetails: onDetails,
              onPay: onPay,
            )
          else
            CustomButton(
              label: 'view_details'.tr(),
              height: 42,
              width: double.infinity,
              onPressed: onDetails,
            ),
        ],
      ),
    );
  }
}

/// The trip photo with its standing pinned to the corner.
class _Photo extends StatelessWidget {
  const _Photo({required this.booking});

  final BookingTripModel booking;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedImage(
            url: booking.image,
            fallbackAsset: HomeAssets.kaaba,
            height: 104,
            width: 124,
          ),
        ),
        PositionedDirectional(
          top: 6,
          start: 6,
          child: TripStatusChip(status: booking.status),
        ),
      ],
    );
  }
}
