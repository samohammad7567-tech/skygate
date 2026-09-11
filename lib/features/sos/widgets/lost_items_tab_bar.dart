import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/features/sos/controller/cubit/lost_items_cubit.dart';

/// The white bar over "المفقودات": two tabs, the picked one in blue over its
/// own underline.
///
/// Binds [LostItemsTab] to [AppTabBar]. Unlike "رحلاتي" the tabs carry no
/// glyphs and the underline runs the full width, which is what the design
/// draws here — both fall out of [AppTabBar]'s defaults.
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
