import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// One tab of an [AppTabBar]: its caption, and the glyph printed after it on
/// the bars that carry one.
class AppTabItem {
  const AppTabItem({required this.labelKey, this.icon});

  /// Translation key of the caption.
  final String labelKey;

  /// Bundled asset drawn after the caption, tinted to match it. Null leaves
  /// the tab text-only, which is what "المفقودات" draws.
  final String? icon;
}

/// The white bar of tabs sitting above a list — the picked one in blue over
/// its own underline.
///
/// Drawn for "رحلاتي" and "المفقودات", which differ only in their metrics and
/// in whether the tabs carry glyphs, so both are settings here rather than a
/// second copy of the bar.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = EdgeInsets.zero,
    this.tabPadding,
    this.underlineGap,
    this.tapRadius,
    this.textStyle,
  });

  final List<AppTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  /// Padding inside the outlined container, around the whole row.
  final EdgeInsetsGeometry padding;

  /// Padding around one tab's contents. The zero bottom keeps the underline
  /// flush with the container's edge.
  final EdgeInsetsGeometry? tabPadding;

  /// Space between a tab's caption and its underline.
  final double? underlineGap;

  final double? tapRadius;

  /// Caption style before the selected/resting colour is applied. Defaults to
  /// the theme's `titleMedium`.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _Tab(
                item: tabs[i],
                isSelected: i == selectedIndex,
                onTap: () => onChanged(i),
                padding: tabPadding ?? EdgeInsets.fromLTRB(8.s, 14.s, 8.s, 0),
                underlineGap: (underlineGap ?? 12.s),
                tapRadius: (tapRadius ?? 12.s),
                textStyle: textStyle ?? theme.textTheme.titleMedium,
              ),
            ),
            if (i != tabs.length - 1)
              SizedBox(
                height: 26.s,
                child: VerticalDivider(
                  width: 1.s,
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
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.padding,
    required this.underlineGap,
    required this.tapRadius,
    required this.textStyle,
  });

  final AppTabItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double underlineGap;
  final double tapRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    final label = Text(
      item.labelKey.tr(),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle?.copyWith(color: color),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(tapRadius),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon case final icon?)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: label),
                  Gap(6.s),
                  AppImage(icon, height: 16.s, width: 16.s, color: color),
                ],
              )
            else
              label,
            Gap(underlineGap),
            // The underline is drawn for every tab so switching does not shift
            // the row; only the picked one is inked.
            Container(
              height: 3.s,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(3.s)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
