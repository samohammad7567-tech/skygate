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
    this.titleColor,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;
  final Widget? action;
  final Color? titleColor;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 12.s),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: AppMenuButton.size.s),
        child: Stack(
          alignment: Alignment.center,
          children: [
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: titleColor,
                  ),
                ),
              ),
            ),
            if (action != null || showBack)
              PositionedDirectional(
                start: 0,
                child: action ?? AppBackButton(onTap: onBack),
              ),
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
