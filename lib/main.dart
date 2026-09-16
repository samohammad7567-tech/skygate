import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/language_service.dart';
import 'package:skygate/core/themes/dark_theme.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/core/utils/navigation_service.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/launch_splash/views/launch_splash_screen.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/tourism/tourism_scope.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheUtil.init();
  DioService.init();
  LanguageService.restore();
  AuthCubit.restoreSession();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LanguageService.apply(context.locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => MainCubit()..loadTheme())],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = context.read<MainCubit>();
          return ScreenUtilInit(
            designSize: const Size(435, 926),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              AppScale.init(context);
              return GetMaterialApp(
                title: 'app_name'.tr(),
                debugShowCheckedModeBanner: false,
                navigatorKey: NavigationService.navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: LightTheme.theme,
                darkTheme: DarkTheme.theme,
                themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
                getPages: tourismPages(),
                defaultTransition: Transition.rightToLeftWithFade,
                transitionDuration: const Duration(milliseconds: 400),
                home: const LaunchSplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
