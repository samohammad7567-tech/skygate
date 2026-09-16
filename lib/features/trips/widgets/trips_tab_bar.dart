import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 4.s),
      tabPadding: EdgeInsets.fromLTRB(4.s, 12.s, 4.s, 0),
      underlineGap: 10,
      tapRadius: 10,
      textStyle: Theme.of(context).textTheme.titleSmall,
    );
  }
}
