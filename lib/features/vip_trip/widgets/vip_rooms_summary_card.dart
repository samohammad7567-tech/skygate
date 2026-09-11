import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/core/models/group_room_type.dart';

class VipRoomsSummaryCard extends StatelessWidget {
  const VipRoomsSummaryCard({super.key, required this.counts});
  final Map<GroupRoomType, int> counts;

  int get _total => counts.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(16);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: radius,
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              children: [
                Text(
                  'rooms_count'.tr(namedArgs: {'count': '$_total'}),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    'rooms_and_types'.tr(),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Only the sizes actually taken are listed, in the sheet's order.
          for (final type in GroupRoomType.values)
            if ((counts[type] ?? 0) > 0) ...[
              Divider(
                height: 1,
                thickness: 1,
                indent: 14,
                endIndent: 14,
                color: theme.colorScheme.outline,
              ),
              _RoomRow(type: type, count: counts[type]!),
            ],
        ],
      ),
    );
  }
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.type, required this.count});

  final GroupRoomType type;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary),
            ),
            child: Text(
              '$count',
              maxLines: 1,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  type.labelKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Gap(5),
                // One glyph per sleeper — the design's shorthand for capacity.
                Wrap(
                  spacing: 3,
                  children: [
                    for (var i = 0; i < type.capacity; i++)
                      AppImage(
                        VipTripAssets.roomBed,
                        height: 11,
                        width: 11,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
