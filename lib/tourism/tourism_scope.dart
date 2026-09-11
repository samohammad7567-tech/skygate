import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_theme.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class TourismScope extends StatelessWidget {
  const TourismScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Theme(data: isArabic ? arThemeData : enThemeData, child: child);
  }
}

List<GetPage> tourismPages() => AppPages.routes
    .map(
      (route) => GetPage(
        name: route.name,
        page: () => TourismScope(child: route.page()),
        binding: route.binding,
      ),
    )
    .toList();
