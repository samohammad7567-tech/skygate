import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/components/app_date_field.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/views/vip_duration_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

void main() {
  setUpAll(() async {
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

  Future<void> pump(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(412, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(screen));
    await tester.pump();
    expect(tester.takeException(), isNull);
  }

  testWidgets('a field whose range starts tomorrow opens without throwing', (
    tester,
  ) async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    await pump(
      tester,
      Scaffold(
        body: AppDateField(
          hint: 'start_date',
          value: null,
          firstDate: tomorrow,
          onPicked: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(AppDateField));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('a value past the end of the range opens without throwing', (
    tester,
  ) async {
    await pump(
      tester,
      Scaffold(
        body: AppDateField(
          hint: 'end_date',
          value: DateTime(2100),
          lastDate: DateTime(2030),
          onPicked: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(AppDateField));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('both dates on the VIP duration step open', (tester) async {
    await pump(
      tester,
      BlocProvider(
        create: (_) => VipTripCubit(),
        child: const VipDurationScreen(),
      ),
    );

    for (final index in [0, 1]) {
      await tester.tap(find.byType(AppDateField).at(index));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'field $index threw');
      expect(find.byType(DatePickerDialog), findsOneWidget);
      Navigator.of(tester.element(find.byType(DatePickerDialog))).pop();
      await tester.pumpAndSettle();
    }
  });

  test('the first selectable date is a date-only tomorrow', () {
    final cubit = VipTripCubit();
    final first = cubit.firstSelectableDate;
    final now = DateTime.now();

    expect(first, DateTime(now.year, now.month, now.day + 1));
    expect(first.hour, 0);
    expect(first.minute, 0);
    cubit.close();
  });
}
