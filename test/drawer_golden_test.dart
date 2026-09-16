import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/main/widgets/app_drawer.dart';
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
        theme: LightTheme.theme,
        home: child,
      ),
    ),
  );

  testWidgets('drawer', (tester) async {
    final cubit = MainCubit();
    addTearDown(cubit.close);

    tester.view.physicalSize = const Size(412, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(
      host(
        BlocProvider.value(
          value: cubit,
          child: Scaffold(key: scaffoldKey, drawer: const AppDrawer()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    scaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();
    await _decodeImages(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/21_drawer.png'),
    );
  });
}

Future<void> _decodeImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in tester.elementList(find.byType(Image))) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pumpAndSettle();
}
