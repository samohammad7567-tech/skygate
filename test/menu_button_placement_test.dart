import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/components/app_back_button.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/home/views/home_screen.dart';
import 'package:skygate/features/main/views/main_screen.dart';
import 'package:skygate/features/main/widgets/app_bottom_nav_bar.dart';
import 'package:skygate/features/map/views/map_screen.dart';
import 'package:skygate/features/profile/views/profile_screen.dart';
import 'package:skygate/features/settings/views/settings_screen.dart';
import 'package:skygate/features/trips/views/trips_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// Every tab answers empty, which is enough: the drawer handle sits in the
/// header, above whatever the body ends up rendering.
class _EmptyAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode({'data': <String, dynamic>{}}),
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await CacheUtil.init();
    DioService.init();
    DioService.dio.httpClientAdapter = _EmptyAdapter();
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

  testWidgets('the drawer handle holds one rect across every tab', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(412, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(BlocProvider(create: (_) => MainCubit(), child: const MainScreen())),
    );
    await tester.pumpAndSettle();

    const tabs = <String, Type>{
      'home': HomeScreen,
      'trips': TripsScreen,
      'map': MapScreen,
      'account': ProfileScreen,
      'settings': SettingsScreen,
    };
    final rects = <String, Rect>{};

    var i = 0;
    for (final tab in tabs.entries) {
      if (i > 0) {
        // Drive the real bottom bar rather than the cubit, so the test walks
        // the same path the reader does. The nav tabs are the InkWells inside
        // the bar — the header chips are InkWells too, so scope the search.
        await tester.tap(
          find
              .descendant(
                of: find.byType(AppBottomNavBar),
                matching: find.byType(InkWell),
              )
              .at(i),
        );
        await tester.pumpAndSettle();
      }

      final handle = find.descendant(
        of: find.byType(tab.value),
        matching: find.byType(AppMenuButton),
      );
      expect(
        handle,
        findsOneWidget,
        reason: 'the ${tab.key} tab draws no drawer handle',
      );
      rects[tab.key] = tester.getRect(handle);

      // A tab root has nothing to pop — the system back button is what walks
      // the reader to الرئيسية and then out of the app.
      expect(
        find.descendant(
          of: find.byType(tab.value),
          matching: find.byType(AppBackButton),
        ),
        findsNothing,
        reason: 'the ${tab.key} tab must not draw a back chip',
      );
      i++;
    }

    for (final entry in rects.entries) {
      debugPrint('${entry.key.padRight(9)} ${entry.value}');
    }

    final first = rects['home']!;
    for (final entry in rects.entries) {
      expect(
        entry.value,
        first,
        reason:
            '${entry.key} puts the handle at ${entry.value}, '
            'but home puts it at $first',
      );
    }
  });
}
