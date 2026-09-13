import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/profile/widgets/profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.title,
    required this.name,
    this.avatarUrl,
    this.onBack,
    this.onMenuTap,
    this.showBack = true,
  });

  final String title;
  final String name;

  final String? avatarUrl;
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;

  /// A tab root has nothing to pop, so the shell's tabs clear this. Every
  /// pushed screen leaves it on.
  final bool showBack;

  /// How far the plate's bottom corners curve into the page under it.
  static const double radius = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPlate = theme.colorScheme.onPrimary;

    // The plate is dark enough that the status bar's own glyphs disappear
    // into it unless they are told to come up light.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        width: double.infinity,
        // The plate runs up under the status bar, so the inset the scaffold
        // would have added is added here instead — inside the colour, and by
        // the same amount, which is what keeps the corner chips level with the
        // other tabs' (`menu_button_placement_test`).
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(radius.s),
          ),
        ),
        child: Column(
          children: [
            // The title row is the shared header, not a copy of it: the tab title
            // has to carry the same size and placement on حسابي as it does on the
            // other tabs, and reusing the widget is what keeps it that way. Only
            // the colour differs, because the plate under it does.
            AppPageHeader(
              title: title,
              onBack: onBack,
              onMenuTap: onMenuTap,
              showBack: showBack,
              titleColor: onPlate,
            ),
            Gap(14.s),
            // The halo is what lifts the portrait off the plate — the avatar's
            // own surface is near enough to white that it needs the gap.
            Container(
              padding: EdgeInsets.all(5.s),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: onPlate.withValues(alpha: 0.16),
              ),
              child: ProfileAvatar(url: avatarUrl, size: 88.s),
            ),
            Gap(14.s),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.s),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 20.fs,
                  color: onPlate,
                ),
              ),
            ),
            Gap(28.s),
          ],
        ),
      ),
    );
  }
}
