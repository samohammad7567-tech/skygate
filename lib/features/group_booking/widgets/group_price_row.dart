import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';

/// One priced line of a room card: the glyph and its caption on the start
/// side, the amount pushed out to the end in orange.
class GroupPriceRow extends StatelessWidget {
  const GroupPriceRow({
    super.key,
    required this.asset,
    required this.labelKey,
    required this.price,
    this.currency,
    this.count,
  });

  final String asset;
  final String labelKey;
  final num? price;
  final String? currency;

  /// Small badge after the caption — how many beds "إغلاق الأسرة" paid for.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          AppImage(
            asset,
            height: 18,
            width: 18,
            color: theme.colorScheme.primary,
          ),
          const Gap(10),
          Flexible(
            child: Text(
              labelKey.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          if (count != null) ...[const Gap(6), _CountBadge(count: count!)],
          const Spacer(),
          Text(
            price == null ? '—' : '$price${currency ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// "المجموع النهائي" line closing a room card.
class GroupTotalRow extends StatelessWidget {
  const GroupTotalRow({
    super.key,
    required this.total,
    required this.labelKey,
    this.currency,
  });

  final num total;
  final String labelKey;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Text(
              labelKey.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const Spacer(),
          Text(
            '$total${currency ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small orange pill carrying the number of beds a lock covers.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 18,
      width: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        maxLines: 1,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
