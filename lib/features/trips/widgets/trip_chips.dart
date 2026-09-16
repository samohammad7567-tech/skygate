import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';

class TripStatusChip extends StatelessWidget {
  const TripStatusChip({super.key, required this.tab});

  final TripsTab tab;

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(
      labelKey: tab.labelKey,
      background: tab.background,
      foreground: tab.foreground,
      borderAlpha: 0.5,
    );
  }
}

class TripDateChip extends StatelessWidget {
  const TripDateChip({super.key, required this.labelKey, required this.date});

  final String labelKey;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 8.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.s),
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
          Gap(2.s),
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

class TripDurationDivider extends StatelessWidget {
  const TripDurationDivider({super.key, required this.days});

  final int? days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rule = Container(height: 1.4.s, color: theme.colorScheme.secondary);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        rule,
        Gap(6.s),
        Text(
          days == null ? '' : 'days_count'.tr(namedArgs: {'count': '$days'}),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        Gap(6.s),
        rule,
      ],
    );
  }
}

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
            padding: EdgeInsetsDirectional.only(end: 8.s),
            child: AppImage(
              asset,
              height: 15.s,
              width: 15.s,
              color: theme.colorScheme.primary,
            ),
          ),
      ],
    );
  }
}
