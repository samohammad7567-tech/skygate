import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/settings/controller/cubit/settings_cubit.dart';
import 'package:skygate/features/settings/models/settings_toggle.dart';
import 'package:skygate/features/settings/views/settings_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await CacheUtil.init();
    DioService.init();
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
        debugShowCheckedModeBanner: false,
        theme: LightTheme.theme,
        home: child,
      ),
    ),
  );

  testWidgets('settings', (tester) async {
    // The page is one scroll taller than a phone; the golden is given the
    // whole of it so a section cannot drift out of frame unnoticed.
    tester.view.physicalSize = const Size(412, 1560);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(const SettingsScreen()));
    await tester.pumpAndSettle();
    await _decodeImages(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/46_settings.png'),
    );
  });

  group('SettingsCubit', () {
    test('a device that has never been asked answers with the defaults', () {
      SharedPreferences.setMockInitialValues({});
      final cubit = SettingsCubit()..loadSettings();
      addTearDown(cubit.close);

      for (final toggle in SettingsToggle.values) {
        expect(cubit.isOn(toggle), toggle.byDefault, reason: toggle.name);
      }
    });

    test('a switch the reader turned off is remembered', () async {
      SharedPreferences.setMockInitialValues({});
      await CacheUtil.init();

      final cubit = SettingsCubit()..loadSettings();
      addTearDown(cubit.close);
      await cubit.toggle(SettingsToggle.biometric, false);
      expect(cubit.isOn(SettingsToggle.biometric), isFalse);

      // A second cubit stands in for the next launch: it reads the store, not
      // the instance that wrote it.
      final next = SettingsCubit()..loadSettings();
      addTearDown(next.close);
      expect(next.isOn(SettingsToggle.biometric), isFalse);
      expect(next.isOn(SettingsToggle.push), isTrue);
    });

    test('the language row and the API header stay in step', () async {
      SharedPreferences.setMockInitialValues({});
      await CacheUtil.init();

      final cubit = SettingsCubit();
      addTearDown(cubit.close);
      expect(cubit.language, 'ar');

      await cubit.changeLanguage('en');
      expect(cubit.language, 'en');
      expect(DioService.dio.options.headers['X-localization'], 'en');
    });
  });
}

/// Asset decoding runs on the real event loop, which the widget tester's fake
/// async never pumps — without this the golden captures empty image boxes.
Future<void> _decodeImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in tester.elementList(find.byType(Image))) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pumpAndSettle();
}
