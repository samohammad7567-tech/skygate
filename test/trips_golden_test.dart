import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/trips/models/trips_tab.dart';
import 'package:skygate/features/trips/views/trips_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

Map<String, dynamic> _trip({
  required int id,
  required String number,
  required String name,
  required String filter,
  List<String> modes = const [],
  int? currentLeg,
  String? image,
}) => <String, dynamic>{
  'id': id,
  'trip_number': number,
  'campaign_name': name,
  'booking_deadline': null,
  'start_date_g': '2026-03-03',
  'start_date_h': null,
  'end_date_g': '2026-03-10',
  'end_date_h': null,
  'access_type': 'public',
  'status': 'published',
  'trip_program_pdf_url': null,
  'price_range': null,
  'trip_image_url': image,
  'is_vip': false,
  'filter_status': filter,
  'duration_days': 7,
  'transport_modes': modes,
  'current_leg': ?currentLeg,
  'booking': {
    'id': 7,
    'booking_reference': 'BK-DEMO-R5AnVN',
    'status': 'confirmed',
    'total_amount': 1200,
    'paid_amount': 1200,
    'remaining_amount': 0,
    'payment_percentage': 100,
    'currency': 'USD',
  },
};

final Map<String, dynamic> _myTrips = {
  'data': {
    'items': [
      _trip(
        id: 12,
        number: '201547',
        name: 'رحلة مكة',
        filter: 'current',
        modes: const ['flight', 'train', 'bus', 'ship', 'flight'],
        currentLeg: 1,
      ),
      _trip(
        id: 11,
        number: 'DEMO-0003',
        name: 'رحلة مكة المباركة - القادمة',
        filter: 'upcoming',
      ),
    ],
    'meta': {
      'pagination': {
        'count': 2,
        'current_page': 1,
        'per_page': 10,
        'total': 2,
        'filter': 'current',
      },
    },
  },
  'message': 'Trips fetched successfully.',
  'status_code': 1,
};

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
    final body = path == 'app/my-trips' ? _myTrips : null;
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
        debugShowCheckedModeBanner: false,
        theme: LightTheme.theme,
        home: child,
      ),
    ),
  );

  testWidgets('my trips', (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(const TripsScreen()));
    await tester.pumpAndSettle();
    await _decodeImages(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/37_my_trips.png'),
    );
  });

  group('the my-trips payload', () {
    TripModel first() => TripModel.fromJson(
      Map<String, dynamic>.from(_myTrips['data']['items'][0]),
    );

    test('reads the nested booking rather than a bookings endpoint', () {
      final booking = first().booking;

      expect(booking?.id, 7);
      expect(booking?.reference, 'BK-DEMO-R5AnVN');
      expect(booking?.currency, 'USD');
      expect(booking?.outstanding, 0);
      expect(booking?.isFullyPaid, isTrue);
    });

    test('prefers the API\'s own duration over the two dates', () {
      expect(first().durationDays, 7);
    });

    test('carries the legs and the bucket the API chose', () {
      final trip = first();

      expect(trip.transportModes, hasLength(5));
      expect(trip.currentLeg, 1);
      expect(TripsTab.fromApi(trip.filterStatus), TripsTab.current);
    });

    test('a trip with no legs and no photo still parses', () {
      final trip = TripModel.fromJson(
        Map<String, dynamic>.from(_myTrips['data']['items'][1]),
      );

      expect(trip.transportModes, isEmpty);
      expect(trip.imageUrl, isNull);
      expect(trip.currentLeg, isNull);
      expect(TripsTab.fromApi(trip.filterStatus), TripsTab.upcoming);
    });

    test('an unknown filter_status falls back to the tab being viewed', () {
      expect(TripsTab.fromApi(null), isNull);
      expect(TripsTab.fromApi('something-else'), isNull);
      expect(TripsTab.fromApi('past'), TripsTab.past);
    });
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
