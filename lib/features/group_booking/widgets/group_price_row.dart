import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_circle_badge.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.s),
      child: Row(
        children: [
          AppImage(
            asset,
            height: 18.s,
            width: 18.s,
            color: theme.colorScheme.primary,
          ),
          Gap(10.s),
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
          if (count != null) ...[Gap(6.s), _CountBadge(count: count!)],
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
      padding: EdgeInsets.symmetric(vertical: 8.s),
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

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCircleBadge(
      text: '$count',
      background: theme.colorScheme.secondary.withValues(alpha: 0.15),
      foreground: theme.colorScheme.secondary,
      textStyle: theme.textTheme.bodySmall,
    );
  }
}
