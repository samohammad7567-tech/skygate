import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/settings/views/settings_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    DioService.init();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheUtil.init();
  });

  Future<void> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 1560);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(const SettingsScreen()));
    await tester.pumpAndSettle();
  }

  List<Switch> switches(WidgetTester tester) =>
      tester.widgetList<Switch>(find.byType(Switch)).toList();

  testWidgets('every switch starts on', (tester) async {
    await open(tester);

    expect(switches(tester), hasLength(5));
    expect(switches(tester).every((s) => s.value), isTrue);
  });

  testWidgets('tapping a switch repaints it without a rebuild from above', (
    tester,
  ) async {
    await open(tester);

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    expect(switches(tester).first.value, isFalse);
    expect(switches(tester).skip(1).every((s) => s.value), isTrue);
  });

  testWidgets('a switch in the privacy section repaints too', (tester) async {
    await open(tester);
    await tester.tap(find.byType(Switch).at(3));
    await tester.pumpAndSettle();

    expect(switches(tester)[3].value, isFalse);
    expect(switches(tester).first.value, isTrue);
  });

  testWidgets('tapping the row, not just the switch, repaints it', (
    tester,
  ) async {
    await open(tester);

    await tester.tap(find.text('settings_push_title'.tr()));
    await tester.pumpAndSettle();

    expect(switches(tester).first.value, isFalse);
  });

  testWidgets('the choice survives reopening the screen', (tester) async {
    await open(tester);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    await tester.pumpWidget(_host(const SizedBox.shrink()));
    await tester.pumpAndSettle();
    await open(tester);

    expect(switches(tester).first.value, isFalse);
  });
}

Widget _host(Widget child) => EasyLocalization(
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
