import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_page_header.dart';

/// The tab still has no settings to show, but it carries the shell's own
/// header rather than `ComingSoonView`'s plain `AppBar`, so the drawer handle
/// lands in the same corner and at the same size as on every other tab.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, this.onMenuTap});

  /// Opens the shell's drawer. The shell owns the panel, so a tab only
  /// forwards the tap.
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'nav_settings'.tr(),
              onMenuTap: onMenuTap,
              // A tab root has nothing to pop; the system back button is what
              // walks the reader to الرئيسية and then out.
              showBack: false,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'coming_soon'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
