import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/features/sos/controller/cubit/lost_items_cubit.dart';

class LostItemsTabBar extends StatelessWidget {
  const LostItemsTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final LostItemsTab selected;
  final ValueChanged<LostItemsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTabBar(
      tabs: [
        for (final tab in LostItemsTab.values)
          AppTabItem(labelKey: tab.labelKey),
      ],
      selectedIndex: selected.index,
      onChanged: (index) => onChanged(LostItemsTab.values[index]),
    );
  }
}
