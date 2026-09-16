import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/main/models/drawer_item_model.dart';

class AppDrawerTile extends StatelessWidget {
  const AppDrawerTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final DrawerItemModel item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.primary;
    final radius = BorderRadius.circular(12.s);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 2.s),
      child: Material(
        color: isSelected
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 13.s),
            child: Row(
              children: [
                AppImage(
                  item.icon,
                  width: 22.s,
                  height: 22.s,
                  color: foreground,
                ),
                Gap(14.s),
                Expanded(
                  child: Text(
                    item.labelKey.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 14.fs,
                      color: foreground,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
