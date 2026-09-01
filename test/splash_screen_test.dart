import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/on_boarding/views/on_boarding_screen.dart';
import 'package:skygate/features/splash/controller/cubit/splash_cubit.dart';
import 'package:skygate/features/splash/models/splash_service.dart';
import 'package:skygate/features/splash/views/splash_screen.dart';
import 'package:skygate/features/splash/widgets/splash_background_carousel.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// Renders the splash entry screen in Arabic on a phone-sized surface and
/// fails on any layout overflow or build exception.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await CacheUtil.init();
  });

  Widget host(Widget child) => EasyLocalization(
    supportedLocales: const [Locale('ar'), Locale('en')],
    path: 'assets/lang',
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    assetLoader: const CodegenLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: LightTheme.theme,
        home: child,
      ),
    ),
  );

  Future<void> pumpSplash(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 861);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(const SplashScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  }

  /// Disposes the tree so the slideshow timer is cancelled with the cubit.
  Future<void> disposeSplash(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  }

  testWidgets('renders the title and both service buttons', (tester) async {
    await pumpSplash(tester);

    expect(find.text('journey_starts_here'.tr()), findsOneWidget);
    expect(find.text('tourism_services'.tr()), findsOneWidget);
    expect(find.text('umrah_services'.tr()), findsOneWidget);
    expect(find.text('or'.tr()), findsOneWidget);

    await disposeSplash(tester);
  });

  testWidgets('the slideshow advances on its own', (tester) async {
    await pumpSplash(tester);

    final controller = tester
        .widget<SplashBackgroundCarousel>(find.byType(SplashBackgroundCarousel))
        .controller;
    expect(controller.page?.round(), 0);

    await tester.pump(SplashCubit.slideInterval);
    await tester.pumpAndSettle();
    expect(controller.page?.round(), 1);
    expect(tester.takeException(), isNull);

    await disposeSplash(tester);
  });

  testWidgets('picking a service stores it and moves on', (tester) async {
    await pumpSplash(tester);

    await tester.tap(find.text('umrah_services'.tr()));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      CacheUtil.get(key: SplashCubit.serviceKey),
      SplashService.umrah.cacheValue,
    );
    // First run: onboarding has not been seen yet.
    expect(find.byType(OnBoardingScreen), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);

    await disposeSplash(tester);
  });
}
