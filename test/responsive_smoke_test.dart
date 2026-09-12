import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/features/settings/views/settings_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// The widths the layout has to survive, either side of the 412 it was drawn
/// on: the narrowest phone Android still ships, a large phone, and a tablet
/// past the point where [AppScale] stops growing and starts adding margin.
const Map<String, Size> _windows = {
  'a 320-wide phone': Size(320, 640),
  'a 480-wide phone': Size(480, 1000),
  'a 800-wide tablet': Size(800, 1200),
};

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await CacheUtil.init();
    DioService.init();
  });

  tearDown(AppScale.reset);

  /// A `RenderFlex` that overruns its box throws, and `pumpWidget` reports it
  /// — so composing each screen on each window is the assertion.
  void checkEveryWindow(
    String name,
    Widget Function() build, {
    Future<void> Function(WidgetTester)? after,
  }) {
    for (final entry in _windows.entries) {
      testWidgets('$name composes on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_host(build()));
        await tester.pumpAndSettle();
        await after?.call(tester);

        expect(tester.takeException(), isNull);
      });
    }
  }

  checkEveryWindow('the settings page', () => const SettingsScreen());

  // The panel is behind the shell, so it has to be pulled out before there is
  // anything to lay out — a closed drawer builds nothing and would pass on any
  // window at all.
  final scaffoldKey = GlobalKey<ScaffoldState>();

  checkEveryWindow(
    'the drawer',
    () {
      final cubit = MainCubit();
      addTearDown(cubit.close);
      return BlocProvider.value(
        value: cubit,
        child: Scaffold(
          key: scaffoldKey,
          drawer: const AppDrawer(),
          body: const SizedBox.shrink(),
        ),
      );
    },
    after: (tester) async {
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();
      expect(find.byType(AppDrawer), findsOneWidget);
    },
  );
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
      // Seeded here, the way the app root seeds it, so everything below
      // builds against the window the test set.
      builder: (context, child) {
        AppScale.init(context);
        return child!;
      },
      home: child,
    ),
  ),
);
