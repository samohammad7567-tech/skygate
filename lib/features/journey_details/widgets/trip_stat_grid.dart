import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/journey_details/models/journey_package_model.dart';

class TripStatGrid extends StatelessWidget {
  const TripStatGrid({super.key, required this.package});

  final JourneyPackageModel? package;

  List<_Stat> _stats() {
    final trip = package;
    if (trip == null) return const [];

    return [
      for (final stay in trip.stays)
        _Stat(
          asset: stay.icon,
          label: stay.city ?? '',
          value: 'days_count'.tr(namedArgs: {'count': '${stay.days ?? 0}'}),
        ),
      if (trip.pilgrimsCount case final count?)
        _Stat(
          asset: PaymentAssets.group,
          label: 'pilgrims_count'.tr(),
          value: '$count',
        ),
      if (trip.daysRemaining case final left?)
        _Stat(
          asset: PaymentAssets.calendar,
          label: 'days_remaining'.tr(),
          value: 'days_count'.tr(namedArgs: {'count': '$left'}),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats();
    if (stats.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < stats.length; i += 2) ...[
          if (i > 0) SizedBox(height: 12.s),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _Tile(stat: stats[i])),
                SizedBox(width: 12.s),
                Expanded(
                  child: i + 1 < stats.length
                      ? _Tile(stat: stats[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Stat {
  const _Stat({required this.asset, required this.label, required this.value});

  final String asset;
  final String label;
  final String value;
}

class _Tile extends StatelessWidget {
  const _Tile({required this.stat});

  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.all(10.s),
      child: Row(
        children: [
          AppGlyphPlate(asset: stat.asset, size: 38.s, glyphSize: 19.s),
          SizedBox(width: 10.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(height: 2.s),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
