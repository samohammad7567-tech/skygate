import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_menu_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        // The plate runs under the status bar, so the row — not the plate —
        // is what the inset pushes down.
        MediaQuery.paddingOf(context).top + 12,
        20,
        26,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Column(
        children: [
          ConstrainedBox(
            // The corner chips are AppMenuButton.size tall and sit positioned, so
            // they do not grow the stack. Without a floor it shrinks to the title
            // text, which differs per screen — the chips then overflow (clipped by
            // the stack) and land at a different height on every tab.
            constraints: const BoxConstraints(minHeight: AppMenuButton.size),
            child: Stack(
              alignment: Alignment.center,
              children: [
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
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                if (onMenuTap != null)
                  PositionedDirectional(
                    start: 0,
                    child: AppMenuButton(onTap: onMenuTap),
                  ),
                if (showBack)
                  PositionedDirectional(
                    end: 0,
                    child: AppBackButton(onTap: onBack),
                  ),
              ],
            ),
          ),
          const Gap(18),
          ProfileAvatar(url: avatarUrl, size: 92),
          const Gap(12),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
