import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';
import 'package:skygate/features/booking_changes/views/booking_change_requests_screen.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

/// One row of `app/booking-change-requests`, shaped the way
/// `BookingChangeRequestResource` publishes it — `details`, `status` and
/// `admin_notes` all come back as lists.
Map<String, dynamic> _request({
  required int id,
  required String type,
  required String status,
}) => <String, dynamic>{
  'id': id,
  'booking_id': 16,
  'request_type': type,
  'details': const ['تفاصيل الطلب كما أرسلها المعتمر'],
  'status': [status],
  'admin_notes': const [],
  'reviewed_at': status == 'pending' ? null : '2026-09-02T10:15:00.000000Z',
  'created_at': '2026-08-30T08:00:00.000000Z',
  'booking': {
    'booking_number': '15454521651',
    'trip': {'campaign_name': 'رحلة مكة', 'trip_number': '201547'},
  },
};

final Map<String, dynamic> _requests = {
  'data': [
    _request(id: 1, type: 'full_cancel', status: 'completed'),
    _request(id: 2, type: 'modify_date', status: 'pending'),
    _request(id: 3, type: 'add_pilgrims', status: 'rejected'),
    _request(id: 4, type: 'change_room', status: 'pending'),
    _request(id: 5, type: 'partial_cancel', status: 'approved'),
  ],
  'meta': {
    'pagination': {'count': 5, 'per_page': 15, 'has_more_pages': false},
  },
  'message': 'Booking change requests fetched successfully.',
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
    final body = path == 'app/booking-change-requests' ? _requests : null;
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

  testWidgets('booking amendment requests', (tester) async {
    tester.view.physicalSize = const Size(412, 1120);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(const BookingChangeRequestsScreen()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/45_booking_change_requests.png'),
    );
  });

  group('the booking-change-requests payload', () {
    BookingChangeRequestModel at(int index) =>
        BookingChangeRequestModel.fromJson(
          Map<String, dynamic>.from(_requests['data'][index]),
        );

    test('names the booking from the block nested beside it', () {
      final request = at(0);

      expect(request.tripTitle, 'رحلة مكة');
      expect(request.reference, '15454521651');
      expect(request.bookingId, 16);
    });

    test('reads the five request types the API accepts', () {
      expect(at(0).type, BookingChangeType.fullCancel);
      expect(at(1).type, BookingChangeType.modifyDate);
      expect(at(2).type, BookingChangeType.addPilgrims);
      expect(at(3).type, BookingChangeType.changeRoom);
      expect(at(4).type, BookingChangeType.partialCancel);
      expect(at(0).isKnownType, isTrue);
    });

    test('a type this build does not know keeps the API wording', () {
      final request = BookingChangeRequestModel.fromJson({
        'id': 9,
        'request_type': 'change_route',
      });

      expect(request.isKnownType, isFalse);
      expect(request.typeLabel, 'change_route');
    });

    test('reads the standing out of the list the resource sends', () {
      expect(at(0).status, BookingChangeStatus.done);
      expect(at(1).status, BookingChangeStatus.pending);
      expect(at(2).status, BookingChangeStatus.rejected);
      expect(at(4).status, BookingChangeStatus.approved);
    });

    test('an unanswered request carries no review date', () {
      expect(at(1).reviewedAt, isNull);
      expect(at(0).reviewedAt, isNotNull);
      expect(at(0).createdAt, isNotNull);
    });

    test('a row with nothing but an id still parses', () {
      final request = BookingChangeRequestModel.fromJson({'id': 3});

      expect(request.status, BookingChangeStatus.pending);
      expect(request.type, BookingChangeType.other);
      expect(request.reference, '3');
      expect(request.detailsText, isNull);
      expect(request.adminNotesText, isNull);
    });
  });
}
