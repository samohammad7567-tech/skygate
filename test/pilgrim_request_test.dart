import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await CacheUtil.init();
  });

  test('toPilgrimJson keeps is_self a real boolean, either way', () {
    final passport = PassportDataModel(fullNameAr: 'نورة عبدالله الفهد');

    final own = passport.toPilgrimJson(isSelf: true);
    expect(own['is_self'], isA<bool>());
    expect(own['is_self'], isTrue);
    final companion = passport.toPilgrimJson(isSelf: false);
    expect(companion.containsKey('is_self'), isTrue);
    expect(companion['is_self'], isFalse);
  });

  test('submit posts the pilgrim as JSON, not multipart', () async {
    DioService.init();
    final adapter = _CapturingAdapter();
    DioService.dio.httpClientAdapter = adapter;

    final cubit = BookingCubit(1);
    addTearDown(cubit.close);

    cubit.passportForm
      ..fullNameArController.text = 'نورة عبدالله الفهد'
      ..fullNameEnController.text = 'Noura Abdullah Al-Fahad'
      ..passportNumberController.text = 'C123987655'
      ..nationalityController.text = 'SA'
      ..gender = 'female'
      ..birthDate = DateTime(1988, 3, 22)
      ..expiryDate = DateTime(2033, 6, 15);

    await cubit.submit();

    final request = adapter.requests.firstWhere(
      (options) => options.path == ApiEndpoints.pilgrims,
    );

    expect(
      request.data,
      isA<Map<String, dynamic>>(),
      reason: 'a FormData body would stringify is_self',
    );
    expect(request.headers[Headers.contentTypeHeader], contains('json'));

    final body = request.data as Map<String, dynamic>;
    expect(body['is_self'], isTrue);
    expect(body['is_self'], isA<bool>());
    expect(body['full_name'], 'نورة عبدالله الفهد');
    expect(body['passport_number'], 'C123987655');
    expect(body['passport_expiry_date'], '2033-06-15');
    expect(body['date_of_birth'], '1988-03-22');
    expect(body['gender'], 'female');
    expect(body['nationality'], 'SA');
    expect(body.values.any((value) => value == null || value == ''), isFalse);
  });
}

class _CapturingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{"data":{"id":5},"message":"Pilgrim registered successfully",'
      '"status_code":1}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
