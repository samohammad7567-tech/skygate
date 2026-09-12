import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // The title row is the shared header, not a copy of it: the tab title
        // has to carry the same colour and size on حسابي as it does on the
        // other tabs, and reusing the widget is what keeps it that way.
        AppPageHeader(
          title: title,
          onBack: onBack,
          onMenuTap: onMenuTap,
          showBack: showBack,
        ),
        Gap(6.s),
        ProfileAvatar(url: avatarUrl, size: 92.s),
        Gap(12.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.s),
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20.fs),
          ),
        ),
        Gap(20.s),
      ],
    );
  }
}
