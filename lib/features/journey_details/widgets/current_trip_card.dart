import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_panel.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';

/// The white panel that tops "تفاصيل الرحلة", "مسار الرحلة" and "جدول اليوم":
/// which trip is running, its number, and the two ends of it with the length
/// ruled in gold between them.
///
/// The three screens draw it identically, so it lives here rather than being
/// rebuilt on each of them.
class CurrentTripCard extends StatelessWidget {
  const CurrentTripCard({super.key, required this.package});

  final JourneyPackageModel? package;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.fromLTRB(16.s, 16.s, 16.s, 16.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Titled(labelKey: 'current_trip', value: package?.title),
              ),
              SizedBox(width: 12.s),
              Expanded(
                child: _Titled(
                  labelKey: 'trip_number',
                  value: package?.tripNumber,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.s),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _EndBox(
                    labelKey: 'outbound',
                    date: package?.startDate,
                    city: package?.departureCity,
                  ),
                ),
                Expanded(child: _Length(days: package?.durationDays)),
                Expanded(
                  child: _EndBox(
                    labelKey: 'inbound',
                    date: package?.endDate,
                    city: package?.returnCity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A small caption over the value it names.
class _Titled extends StatelessWidget {
  const _Titled({
    required this.labelKey,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
  });

  final String labelKey;
  final String? value;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: 2.s),
        Text(
          value ?? '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
      ],
    );
  }
}

/// One end of the trip: which direction, the date split over two lines, and
/// the city that leg sets off from.
class _EndBox extends StatelessWidget {
  const _EndBox({
    required this.labelKey,
    required this.date,
    required this.city,
  });

  final String labelKey;
  final DateTime? date;
  final String? city;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale.languageCode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 10.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.s),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 4.s),
          Text(
            AppFormat.dayMonth(date, locale),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            date == null ? '' : '${date!.year}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 2.s),
          Text(
            city ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
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

/// How long the trip runs, ruled in gold between the two ends.
class _Length extends StatelessWidget {
  const _Length({required this.days});

  final int? days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(height: 1.s),
          const Spacer(),
          Text(
            days == null ? '' : 'days_count'.tr(namedArgs: {'count': '$days'}),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.accent),
          ),
          SizedBox(height: 4.s),
          Container(height: 1.4.s, color: AppColors.accent),
          const Spacer(),
        ],
      ),
    );
  }
}
