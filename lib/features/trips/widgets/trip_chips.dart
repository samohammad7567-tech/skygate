import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';

/// "حالية / بانتظار الدفع / منتهية" — the pill floating on a card's photo.
class TripStatusChip extends StatelessWidget {
  const TripStatusChip({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.foreground.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.labelKey.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: status.foreground),
      ),
    );
  }
}

/// "الذهاب — 3 مارس 2026" — one of the two tinted date blocks on a card, with
/// the trip length printed between them.
class TripDateChip extends StatelessWidget {
  const TripDateChip({super.key, required this.labelKey, required this.date});

  final String labelKey;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            labelKey.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const Gap(2),
          Text(
            AppFormat.shortDate(date, context.locale.languageCode),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// The orange "7 أيام" between the two date blocks, on its own hairline.
class TripDurationDivider extends StatelessWidget {
  const TripDurationDivider({super.key, required this.days});

  final int? days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          days == null ? '' : 'days_count'.tr(namedArgs: {'count': '$days'}),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const Gap(4),
        Container(height: 1.4, color: theme.colorScheme.secondary),
      ],
    );
  }
}

/// The row of service glyphs above a card's title.
///
/// These are the six things every Sky Gate package covers, so the row is
/// design content rather than anything the booking carries.
class TripInclusionsRow extends StatelessWidget {
  const TripInclusionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (final asset in PaymentAssets.inclusions)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: AppImage(
              asset,
              height: 15,
              width: 15,
              color: theme.colorScheme.primary,
            ),
          ),
      ],
    );
  }
}
