import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ActivityLegendBar extends StatelessWidget {
  const ActivityLegendBar({super.key, required this.kinds});

  final List<ActivityKind> kinds;

  @override
  Widget build(BuildContext context) {
    if (kinds.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 12.s),
        child: AppCard(
          padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 10.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (final kind in kinds) _LegendChip(kind: kind)],
          ),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.kind});

  final ActivityKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 5.s),
      decoration: BoxDecoration(
        color: kind.surface,
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppImage(kind.icon, height: 15.s, width: 15.s, color: kind.color),
          SizedBox(width: 6.s),
          Text(
            kind.labelKey.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: kind.color),
          ),
        ],
      ),
    );
  }
}
