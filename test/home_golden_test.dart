import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/home/controller/cubit/home_cubit.dart';
import 'package:skygate/features/home/views/home_screen.dart';
import 'package:skygate/features/main/widgets/app_bottom_nav_bar.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// The `GET app/home` payload, in the shape the API documentation publishes:
/// the profile, the cities the search narrows by, the notifications behind the
/// bell, a page of published trips and the VIP shortlist. Swapping
/// `DioService.dio`'s adapter lets the real cubit run against it, so the
/// golden exercises the screen rather than a stand-in.
final Map<String, Map<String, dynamic>> _responses = {
  'app/home': {'data': _home},
};

final Map<String, dynamic> _home = {
  'user': {
    'id': 562,
    'full_name': 'ليلى أحمد',
    'mobile': '+966512398799',
    'email': 'laila.ahmed@example.com',
    'nationality': 'SA',
    'status': 'active',
    'lang': 'ar',
    'avatar': '',
    'gender': 'female',
  },
  'cities': [
    for (var i = 0; i < 3; i++)
      {
        'id': 10 + i,
        'country_id': 5 + i,
        'country': '${5 + i}',
        'city': ['جدة', 'اسطنبول', 'دبي'][i],
      },
  ],
  'notifications': [
    {
      'id': 1,
      'title': 'اقترب موعد الدفعة الأولى',
      'body': 'يرجى استكمال الدفعة الأولى قبل انتهاء المهلة.',
      'type': 'payment',
      'created_at': '2026-02-20T09:00:00.000000Z',
      'read_at': null,
    },
  ],
  'trips': {
    'items': [for (var i = 0; i < 3; i++) _trip(941 + i)],
    'meta': {
      'per_page': 6,
      'current_page': 1,
      'total': 4,
      'has_more_pages': false,
    },
  },
  'vip_trips': [_trip(950, vip: true)],
};

Map<String, dynamic> _trip(int id, {bool vip = false}) => {
  'id': id,
  'trip_number': 'UMR-2026-00$id',
  'campaign_name': vip ? 'رحلة العمرة المميزة' : 'رحلة العمرة المباركة',
  'booking_deadline': '2026-09-29 12:06:16',
  'start_date_g': '2026-10-06',
  'start_date_h': '1447-09-01',
  'end_date_g': '2026-10-21',
  'end_date_h': '1447-09-15',
  'access_type': 'public',
  'status': 'published',
  'trip_program_pdf_url': null,
  'price_range': {'min': 750, 'max': 1500, 'currency': 'SAR'},
};

/// Answers straight from [_responses] so no socket is ever opened.
class _StubAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path.replaceFirst(
      RegExp(r'^/api/v1/(guest/)?'),
      '',
    );
    final body = _responses[path];
    return ResponseBody.fromString(
      jsonEncode(body ?? {}),
      body == null ? 404 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

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
    DioService.dio.httpClientAdapter = _StubAdapter();
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

  testWidgets('home', (tester) async {
    // The carousel is filled from `GET app/home`, which the screen calls on
    // its first frame — the VIP trip first, then the published ones.
    final cubit = HomeCubit();
    addTearDown(cubit.close);

    tester.view.physicalSize = const Size(412, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(
        BlocProvider.value(
          value: cubit,
          child: const Scaffold(
            extendBody: true,
            body: HomeScreen(),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: 0,
              onTap: _ignore,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _decodeImages(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/20_home.png'),
    );
  });
}

void _ignore(int _) {}

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
