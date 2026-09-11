import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/features/sos/models/lost_item_model.dart';

class LostStatusFilter extends StatelessWidget {
  const LostStatusFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final LostItemStatus? selected;
  final ValueChanged<LostItemStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<LostItemStatus?>(
      onSelected: onChanged,
      initialValue: selected,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      itemBuilder: (_) => [
        PopupMenuItem<LostItemStatus?>(
          value: null,
          child: _MenuLabel(labelKey: 'lost_status_all'),
        ),
        for (final status in LostItemStatus.values)
          PopupMenuItem<LostItemStatus?>(
            value: status,
            child: _MenuLabel(labelKey: status.labelKey),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const Gap(6),
            Text(
              (selected?.labelKey ?? 'lost_status_all').tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const Gap(6),
            AppImage(
              SosAssets.filter,
              height: 16,
              width: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel({required this.labelKey});

  final String labelKey;

  @override
  Widget build(BuildContext context) => Text(
    labelKey.tr(),
    textAlign: TextAlign.end,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: Theme.of(context).textTheme.bodyMedium,
  );
}
