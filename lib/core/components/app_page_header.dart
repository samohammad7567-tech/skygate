import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_menu_button.dart';

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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: ConstrainedBox(
        // The corner chips are AppMenuButton.size tall and sit positioned, so
        // they do not grow the stack. Without a floor it shrinks to the title
        // text, which differs per screen — the chips then overflow (clipped by
        // the stack) and land at a different height on every tab.
        constraints: const BoxConstraints(minHeight: AppMenuButton.size),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Stretched so the stack is as wide as the row: without it the
            // stack shrink-wraps the title and the chips below land beside the
            // text instead of on the page corners.
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppBackButton.size + 8,
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
            if (onMenuTap != null)
              PositionedDirectional(
                start: 0,
                child: AppMenuButton(onTap: onMenuTap),
              ),
            if (action != null || showBack)
              PositionedDirectional(
                end: 0,
                child: action ?? AppBackButton(onTap: onBack),
              ),
          ],
        ),
      ),
    );
  }
}
