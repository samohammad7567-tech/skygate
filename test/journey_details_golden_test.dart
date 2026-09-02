import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/views/activities_screen.dart';
import 'package:skygate/features/journey_details/views/hotel_details_screen.dart';
import 'package:skygate/features/journey_details/views/hotels_screen.dart';
import 'package:skygate/features/journey_details/views/itinerary_screen.dart';
import 'package:skygate/features/journey_details/views/package_details_screen.dart';
import 'package:skygate/features/journey_details/views/segment_details_screen.dart';
import 'package:skygate/features/journey_details/views/trip_offers_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// Canned bodies for every path the flow calls, keyed the way `DioService`
/// builds them. Swapping `DioService.dio`'s adapter lets the real cubits run
/// against them, so the goldens exercise the screens rather than a stand-in.
///
/// The whole flow reads two endpoints: the trip, which carries its packages,
/// hotels, itinerary and staff, and the activities programme.
final Map<String, Map<String, dynamic>> _responses = {
  'app/trips/1': {'data': _trip},
  'app/activities': {'data': _activities},
};

final Map<String, dynamic> _trip = {
  'id': 1,
  'trip_number': 'TR-1044',
  'campaign_name': 'رحلة مكة',
  'start_date_g': '2026-03-03',
  'end_date_g': '2026-03-09',
  'start_date_h': '1447-09-14',
  'end_date_h': '1447-09-20',
  'access_type': 'public',
  'status': 'published',
  'staff': [
    for (var i = 0; i < 4; i++) {'id': i + 1, 'name': 'الشيخ محمد محمد حسان'},
  ],
  'packages': [
    for (var i = 0; i < 3; i++)
      {
        'id': i + 1,
        'room_type': ['twin', 'quad', 'quint'][i],
        'audience': 'المسار البري',
        'price_adult': '750.00',
        'price_child': '600.00',
        'price_infant': '100.00',
        'price_infant_with_seat': '250.00',
        'bed_lock_fee': '150.00',
        'currency': 'SAR',
      },
  ],
  'hotels': [for (var i = 0; i < 4; i++) _hotel(101 + i)],
  'itinerary': [
    _leg(11, 1, 'flight', 'السورية للطيران', 'جدة', 'الرياض'),
    _leg(12, 2, 'bus', 'مواصلات جدة', 'الرياض', 'المدينة المنورة'),
    _leg(13, 3, 'train', 'السورية للقطارات', 'المدينة المنورة', 'جدة'),
    _leg(14, 4, 'cruise', 'سفن جدة', 'جدة', 'مكة المكرمة'),
  ],
};

Map<String, dynamic> _leg(
  int id,
  int order,
  String type,
  String carrier,
  String from,
  String to,
) => {
  'id': id,
  'sequence_order': order,
  'segment_type': type,
  'origin_city': from,
  'destination_city': to,
  'carrier': carrier,
  'departure_time': '2026-03-03 08:00:00',
  'arrival_time': '2026-03-03 10:15:00',
};

Map<String, dynamic> _hotel(int id) => {
  'id': id,
  'name': 'فندق إطلالة مكة الفاخر',
  'city': id.isOdd ? 'مكة المكرمة' : 'المدينة المنورة',
  'rating': '4.5',
  'latitude': '21.42251',
  'longitude': '39.82616',
  'address_details': ['شارع الملك فيصل الطريق الأول', 'مكة المكرمة'],
  'contact_phone': '+966500000000',
  'check_in_date': '2026-08-18',
  'check_out_date': '2026-08-22',
  'is_default': id == 101,
};

final List<Map<String, dynamic>> _activities = [
  for (var day = 0; day < 5; day++)
    for (final type in ['إقامة', 'مناسك', 'صلاة'])
      {
        'id': day * 10 + type.length,
        'title': 'مناسك العمرة - أول طواف',
        'activity_date': '2026-03-0${day + 3}',
        'start_time': '00:30',
        'end_time': '04:00',
        'meeting_point_lat': '21.42251',
        'meeting_point_lng': '39.82616',
        'meeting_point_text': 'شارع الملك فيصل الطريق الأول ، مكة',
        'status': 'scheduled',
        'activity_type': {'id': 1, 'name': type},
      },
];

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

  // The trip is kept for the session, so each shot starts from the network.
  setUp(TripService.clear);

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
    await _decodeImages(tester);

    await expectLater(find.byType(MaterialApp), matchesGoldenFile(name));
  }

  /// The leg the "تفاصيل القسم" shot opens, built the way the itinerary hands
  /// it over.
  JourneySegmentModel firstLeg() => JourneySegmentModel.fromItinerary(
    TripItineraryModel.fromJson(
      _leg(11, 1, 'flight', 'السورية للطيران', 'جدة', 'الرياض'),
    ),
  );

  /// The hotel the "تفاصيل الحجز" shot opens, built the way the list hands it
  /// over.
  HotelModel firstHotel() =>
      HotelModel.fromTripHotel(TripHotelModel.fromJson(_hotel(101)));

  testWidgets('package details', (t) async {
    await shoot(
      t,
      const PackageDetailsScreen(tripId: 1),
      'goldens/30_package_details.png',
      const Size(412, 1084),
    );
  });

  testWidgets('itinerary', (t) async {
    await shoot(
      t,
      const ItineraryScreen(tripId: 1),
      'goldens/31_itinerary.png',
      const Size(412, 1400),
    );
  });

  testWidgets('segment details', (t) async {
    await shoot(
      t,
      SegmentDetailsScreen(tripId: 1, segment: firstLeg()),
      'goldens/32_segment_details.png',
      const Size(412, 1400),
    );
  });

  testWidgets('hotels', (t) async {
    await shoot(
      t,
      const HotelsScreen(tripId: 1),
      'goldens/33_hotels.png',
      const Size(412, 917),
    );
  });

  testWidgets('hotel details', (t) async {
    await shoot(
      t,
      HotelDetailsScreen(tripId: 1, hotel: firstHotel()),
      'goldens/34_hotel_details.png',
      const Size(412, 1400),
    );
  });

  testWidgets('activities', (t) async {
    await shoot(
      t,
      const ActivitiesScreen(),
      'goldens/35_activities.png',
      const Size(412, 917),
    );
  });

  testWidgets('trip offers', (t) async {
    await shoot(
      t,
      const TripOffersScreen(tripId: 1),
      'goldens/36_trip_offers.png',
      const Size(412, 917),
    );
  });
}

/// Asset decoding runs on the real event loop, which the widget tester's fake
/// async never pumps — without this the goldens capture empty image boxes.
Future<void> _decodeImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in tester.elementList(find.byType(Image))) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pumpAndSettle();
}
