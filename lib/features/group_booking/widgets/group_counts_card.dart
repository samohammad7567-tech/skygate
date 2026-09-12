import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/utils/app_scale.dart';

class GroupCountsCard extends StatelessWidget {
  const GroupCountsCard({super.key, required this.counts});
  final Map<TravelerAudience, int> counts;

  int get _total => counts.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.s, 14.s, 16.s, 16.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$_total',
                maxLines: 1,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  'total_travelers'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.s),
          Divider(height: 1.s),
          Gap(14.s),
          Row(
            children: [
              // Reversed so the adults tile sits on the start side, as the
              // design prints it.
              for (final audience in TravelerAudience.values.reversed) ...[
                Expanded(
                  child: _CountTile(
                    labelKey: audience.countLabelKey,
                    count: counts[audience] ?? 0,
                  ),
                ),
                if (audience != TravelerAudience.adult) Gap(12.s),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({required this.labelKey, required this.count});

  final String labelKey;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          height: 40.s,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10.s),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Text(
            '$count',
            maxLines: 1,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Gap(6.s),
        Text(
          labelKey.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
