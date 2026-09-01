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
import 'package:skygate/features/auth/views/passport_confirm_screen.dart';
import 'package:skygate/features/auth/views/passport_manual_screen.dart';
import 'package:skygate/features/auth/views/register_screen.dart';
import 'package:skygate/features/auth/views/register_success_screen.dart';
import 'package:skygate/features/auth/views/umrah_documents_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// Renders every auth screen in Arabic on a phone-sized surface and fails on
/// any layout overflow or build exception.
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

  /// The wizard screens past step 1 expect the shared cubit above them.
  Widget wizard(Widget screen) =>
      BlocProvider(create: (_) => RegisterCubit(), child: screen);

  testWidgets('auth landing renders', (tester) async {
    await pump(tester, const AuthLandingScreen());
  });

  testWidgets('login renders', (tester) async {
    await pump(tester, const LoginScreen());
  });

  testWidgets('register step 1 renders', (tester) async {
    await pump(tester, const RegisterScreen());
  });

  testWidgets('passport confirm renders', (tester) async {
    await pump(tester, wizard(const PassportConfirmScreen()));
  });

  testWidgets('passport manual entry renders', (tester) async {
    await pump(tester, wizard(const PassportManualScreen()));
  });

  testWidgets('pilgrim documents renders', (tester) async {
    await pump(tester, wizard(const UmrahDocumentsScreen()));
  });

  testWidgets('account created renders', (tester) async {
    await pump(tester, const RegisterSuccessScreen());
  });
}
