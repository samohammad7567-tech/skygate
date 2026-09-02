import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';

/// The white bar at the top of "رحلاتي": three tabs, the picked one in blue
/// over its own underline.
class TripsTabBar extends StatelessWidget {
  const TripsTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TripsTab selected;
  final ValueChanged<TripsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          for (final tab in TripsTab.values) ...[
            Expanded(
              child: _Tab(
                tab: tab,
                isSelected: tab == selected,
                onTap: () => onChanged(tab),
              ),
            ),
            if (tab != TripsTab.values.last)
              SizedBox(
                height: 26,
                child: VerticalDivider(
                  width: 1,
                  color: theme.colorScheme.outline,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final TripsTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    tab.labelKey.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(color: color),
                  ),
                ),
                const Gap(6),
                AppImage(tab.icon, height: 16, width: 16, color: color),
              ],
            ),
            const Gap(10),
            // The underline is drawn for every tab so switching does not shift
            // the row; only the picked one is inked.
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
