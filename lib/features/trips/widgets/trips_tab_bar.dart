import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';

/// The white bar at the top of "رحلاتي": three tabs, the picked one in blue
/// over its own underline.
///
/// Binds [TripsTab] to [AppTabBar] and carries this screen's metrics; the bar
/// itself is shared with "المفقودات".
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
    return AppTabBar(
      tabs: [
        for (final tab in TripsTab.values)
          AppTabItem(labelKey: tab.labelKey, icon: tab.icon),
      ],
      selectedIndex: selected.index,
      onChanged: (index) => onChanged(TripsTab.values[index]),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      tabPadding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
      underlineGap: 10,
      tapRadius: 10,
      textStyle: Theme.of(context).textTheme.titleSmall,
    );
  }
}
