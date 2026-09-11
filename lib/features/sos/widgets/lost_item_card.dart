import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_status_chip.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/components/icon_text_row.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/features/sos/models/lost_item_model.dart';

class LostItemCard extends StatelessWidget {
  const LostItemCard({super.key, required this.item, this.onTap});

  final LostItemModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(10),
      radius: 14,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedImage(
              url: item.photo,
              fallbackAsset: item.fallbackPhoto,
              height: 92,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.description ?? '—',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Gap(6),
                _EndAlignedRow(
                  asset: SosAssets.place,
                  text: item.locationHint ?? '—',
                ),
                const Gap(4),
                _EndAlignedRow(
                  asset: SosAssets.date,
                  text: AppFormat.isoDate(item.createdAt),
                ),
                const Gap(8),
                Row(
                  children: [
                    _StatusBadge(status: item.status),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'lost_handled_by'.tr(args: [item.handledBy ?? '—']),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
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

class _EndAlignedRow extends StatelessWidget {
  const _EndAlignedRow({required this.asset, required this.text});

  final String asset;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Flexible(
        child: IconTextRow(asset: asset, text: text),
      ),
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final LostItemStatus status;

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(
      labelKey: status.labelKey,
      background: status.background,
      foreground: status.foreground,
      radius: 8,
    );
  }
}
