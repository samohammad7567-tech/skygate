import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/components/app_menu_button.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/main/models/back_action.dart';
import 'package:skygate/features/main/views/main_screen.dart';
import 'package:skygate/features/main/widgets/app_bottom_nav_bar.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

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

  group('the shell answers the system back button', () {
    late MainCubit cubit;

    /// Only `SystemNavigator.pop` — the call that leaves the app.
    late List<String> platformCalls;

    /// `SystemNavigator.pop()` goes out over the platform channel, so leaving
    /// the app shows up here rather than as anything on screen.
    void watchPlatformChannel(WidgetTester tester) {
      platformCalls = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'SystemNavigator.pop') {
            platformCalls.add(call.method);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
    }

    Future<void> pumpShell(WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      watchPlatformChannel(tester);
      cubit = MainCubit();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        EasyLocalization(
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
              home: BlocProvider.value(value: cubit, child: const MainScreen()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapTab(WidgetTester tester, int index) async {
      await tester.tap(
        find
            .descendant(
              of: find.byType(AppBottomNavBar),
              matching: find.byType(InkWell),
            )
            .at(index),
      );
      await tester.pumpAndSettle();
    }

    Future<void> pressBack(WidgetTester tester) async {
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }

    final exitToast = find.byType(SnackBar);

    testWidgets('a press on any other tab lands on الرئيسية, quietly', (
      tester,
    ) async {
      await pumpShell(tester);
      await tapTab(tester, 4);
      expect(cubit.currentIndex, 4);

      await pressBack(tester);

      expect(cubit.currentIndex, 0, reason: 'back should return to الرئيسية');
      expect(exitToast, findsNothing, reason: 'no warning on the way home');
      expect(platformCalls, isEmpty, reason: 'the app must stay open');
    });

    testWidgets('the first press on الرئيسية warns instead of leaving', (
      tester,
    ) async {
      await pumpShell(tester);

      await pressBack(tester);

      expect(exitToast, findsOneWidget);
      expect(platformCalls, isEmpty, reason: 'one press must not quit');
    });

    testWidgets('a second press inside the window leaves the app', (
      tester,
    ) async {
      await pumpShell(tester);

      await pressBack(tester);
      await pressBack(tester);

      expect(platformCalls, contains('SystemNavigator.pop'));
    });

    testWidgets('an open drawer takes the press before the shell does', (
      tester,
    ) async {
      await pumpShell(tester);
      await tester.tap(find.byType(AppMenuButton));
      await tester.pumpAndSettle();
      expect(find.byType(AppDrawer), findsOneWidget);

      await pressBack(tester);

      expect(
        find.byType(AppDrawer),
        findsNothing,
        reason: 'back should close the drawer first',
      );
      expect(
        exitToast,
        findsNothing,
        reason: 'closing the drawer is not a warning',
      );
      expect(platformCalls, isEmpty);
    });
  });

  group('MainCubit.pressBack', () {
    test('a warning older than the window only warns again', () async {
      final cubit = MainCubit();
      addTearDown(cubit.close);

      expect(cubit.pressBack(), BackAction.warnBeforeExit);
      // Real time, not pumped: the cubit reads the wall clock.
      await Future<void>.delayed(
        MainCubit.exitWindow + const Duration(milliseconds: 150),
      );

      expect(
        cubit.pressBack(),
        BackAction.warnBeforeExit,
        reason: 'a stale press must not quit the app',
      );
      expect(cubit.pressBack(), BackAction.exitApp);
    });

    test('a trip to another tab clears a pending warning', () {
      final cubit = MainCubit();
      addTearDown(cubit.close);

      expect(cubit.pressBack(), BackAction.warnBeforeExit);
      cubit.changeTab(2);
      expect(cubit.pressBack(), BackAction.goHome);
      expect(
        cubit.pressBack(),
        BackAction.warnBeforeExit,
        reason: 'arriving back on الرئيسية starts the warning over',
      );
    });
  });
}
