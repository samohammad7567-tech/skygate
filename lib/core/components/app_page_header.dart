import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onMenuTap,
    this.action,
    this.showBack = true,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;
  final Widget? action;

  /// A tab root has nothing to pop, so the shell's tabs clear this. Every
  /// pushed screen leaves it on.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 12.s),
      child: ConstrainedBox(
        // The corner chips are AppMenuButton.size tall and sit positioned, so
        // they do not grow the stack. Without a floor it shrinks to the title
        // text, which differs per screen — the chips then overflow (clipped by
        // the stack) and land at a different height on every tab.
        constraints: BoxConstraints(minHeight: AppMenuButton.size.s),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Stretched so the stack is as wide as the row: without it the
            // stack shrink-wraps the title and the chips below land beside the
            // text instead of on the page corners.
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppBackButton.size.s + 8.s,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            // Start corner — the right in Arabic. The way back lives here,
            // where both platforms put it; a tab root has nothing to pop and
            // lends the corner to its own action instead.
            if (action != null || showBack)
              PositionedDirectional(
                start: 0,
                child: action ?? AppBackButton(onTap: onBack),
              ),
            // End corner — the drawer handle, away from the way back so the
            // two are never confused for one another.
            if (onMenuTap != null)
              PositionedDirectional(
                end: 0,
                child: AppMenuButton(onTap: onMenuTap),
              ),
          ],
        ),
      ),
    );
  }
}
