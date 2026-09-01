import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';
import 'package:skygate/features/auth/views/auth_landing_screen.dart';
import 'package:skygate/features/auth/views/login_screen.dart';
import 'package:skygate/features/auth/views/passport_manual_screen.dart';
import 'package:skygate/features/auth/views/register_screen.dart';
import 'package:skygate/features/auth/views/register_success_screen.dart';
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

  Future<void> shoot(
    WidgetTester tester,
    Widget screen,
    String name,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(host(screen));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile(name));
  }

  testWidgets('landing', (t) async {
    await shoot(
      t,
      const AuthLandingScreen(),
      'goldens/1_landing.png',
      const Size(412, 917),
    );
  });
  testWidgets('login', (t) async {
    await shoot(
      t,
      const LoginScreen(),
      'goldens/2_login.png',
      const Size(412, 917),
    );
  });
  testWidgets('register', (t) async {
    await shoot(
      t,
      const RegisterScreen(),
      'goldens/4_register.png',
      const Size(412, 1700),
    );
  });
  testWidgets('manual', (t) async {
    await shoot(
      t,
      BlocProvider(
        create: (_) => RegisterCubit(),
        child: const PassportManualScreen(),
      ),
      'goldens/8_manual.png',
      const Size(412, 1400),
    );
  });
  testWidgets('success', (t) async {
    await shoot(
      t,
      const RegisterSuccessScreen(),
      'goldens/11_success.png',
      const Size(412, 917),
    );
  });
}
