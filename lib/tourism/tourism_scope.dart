import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_theme.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

/// Puts the tourism module's own [ThemeData] back over its screens.
///
/// The module shipped as its own app with `theme: arThemeData` on its
/// `GetMaterialApp`; under the shell that slot belongs to the Umrah theme, so
/// each tourism route carries its theme itself. Without this its 53 screens
/// would silently lose the Hacen font and their text scale.
class TourismScope extends StatelessWidget {
  const TourismScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Theme(data: isArabic ? arThemeData : enThemeData, child: child);
  }
}

/// The module's routes, each wrapped in [TourismScope].
///
/// Rebuilt rather than copied: [GetPage] has no `copyWith` in get 4.7, and all
/// 53 routes set only these three fields.
List<GetPage> tourismPages() => AppPages.routes
    .map(
      (route) => GetPage(
        name: route.name,
        page: () => TourismScope(child: route.page()),
        binding: route.binding,
      ),
    )
    .toList();
