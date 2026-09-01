import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/features/home/models/offer_model.dart';

/// Departure chip · duration · return chip, in the design's reading order.
class OfferDatesRow extends StatelessWidget {
  const OfferDatesRow({super.key, required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: OfferDateChip(
            label: 'departure'.tr(),
            date: offer.departureDate,
          ),
        ),
        Expanded(child: _DurationDivider(days: offer.durationDays)),
        Expanded(
          child: OfferDateChip(
            label: 'return_date'.tr(),
            date: offer.returnDate,
          ),
        ),
      ],
    );
  }
}

/// Tinted box holding one leg's label and date.
class OfferDateChip extends StatelessWidget {
  const OfferDateChip({super.key, required this.label, required this.date});

  final String label;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          Text(
            date == null ? '—' : DateFormat.MMMd(locale).format(date!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            date == null ? '' : DateFormat.y(locale).format(date!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Orange rule with the trip length floating in the middle.
class _DurationDivider extends StatelessWidget {
  const _DurationDivider({required this.days});

  final int? days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: theme.colorScheme.secondary),
        ),
        if (days != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'days_count'.tr(namedArgs: {'count': '$days'}),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Expanded(
          child: Container(height: 1, color: theme.colorScheme.secondary),
        ),
      ],
    );
  }
}
