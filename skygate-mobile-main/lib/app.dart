import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_theme.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/modules/language/language_controller.dart';
import 'package:sky_gate/app/routes/app_pages.dart';
import 'dart:ui' as UI;
import 'app/root_binding.dart';


class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      initState: (_) async {
        await languageController.initLanguage();
      },
      init: languageController,
      builder: (languageController) => ScreenUtilInit(
          designSize: const Size(435, 926),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context,child) {
            return GetMaterialApp(
              key: Key(languageController.appLanguage),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: Locale(languageController.appLanguage),
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,
              theme: (languageController.appLanguage == 'en')? enThemeData:arThemeData,
              transitionDuration: const Duration(milliseconds: 400),
              defaultTransition:(languageController.appLanguage == 'en')? Transition.rightToLeftWithFade:Transition.leftToRightWithFade,
              fallbackLocale: const Locale('en'),
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              initialBinding: RootBinding(),
              textDirection: (languageController.appLanguage == 'en')? UI.TextDirection.ltr : UI.TextDirection.rtl,
            );
          }
      ),
    );
  }
}
