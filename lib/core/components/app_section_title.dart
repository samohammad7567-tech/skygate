import 'package:flutter/material.dart';

/// The heading that names a stack of [AppListCard] rows — "الإشعارات",
/// "الخصوصية والأمان", "معلومات الحساب". It hangs on the start edge, which is
/// the right in Arabic.
class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({super.key, required this.text, this.color});

  final String text;

  /// Left unset the heading takes the theme's title colour, which is what the
  /// profile draws; the settings screen tints its headings with the brand.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge?.copyWith(color: color),
      ),
    );
  }
}
