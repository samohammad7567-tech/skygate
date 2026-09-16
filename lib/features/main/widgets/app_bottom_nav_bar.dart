import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/main/models/nav_item_model.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.s, 0, 16.s, 12.s),
        padding: EdgeInsets.all(6.s),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(24.s),
        ),
        child: Row(
          children: [
            for (var i = 0; i < NavItemModel.items.length; i++)
              Expanded(
                child: _NavTab(
                  item: NavItemModel.items[i],
                  isSelected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NavItemModel item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.s),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.s, horizontal: 2.s),
        decoration: BoxDecoration(
          color: isSelected
              ? foreground.withValues(alpha: 0.22)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.s),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage(item.icon, width: 22.s, height: 22.s, color: foreground),
            SizedBox(height: 4.s),
            Text(
              item.labelKey.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
