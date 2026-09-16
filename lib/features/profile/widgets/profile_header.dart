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
  final bool showBack;
  static const double radius = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPlate = theme.colorScheme.onPrimary;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(radius.s),
          ),
        ),
        child: Column(
          children: [
            AppPageHeader(
              title: title,
              onBack: onBack,
              onMenuTap: onMenuTap,
              showBack: showBack,
              titleColor: onPlate,
            ),
            Gap(14.s),
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
