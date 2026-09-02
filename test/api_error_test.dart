import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/utils/api_error.dart';

/// The failures the auth calls actually hit, and the line each one shows.
void main() {
  final request = RequestOptions(path: 'auth/login');

  DioException dio(
    DioExceptionType type, {
    Object? error,
    Response? response,
    String path = 'auth/login',
  }) => DioException(
    requestOptions: RequestOptions(path: path),
    type: type,
    error: error,
    response: response,
  );

  Response body(int status, Object? data) =>
      Response(requestOptions: request, statusCode: status, data: data);

  test('an unreachable host reads as "no connection", not a generic error', () {
    expect(
      ApiError.messageOf(dio(DioExceptionType.connectionError)),
      ApiError.offline,
    );
    expect(
      ApiError.messageOf(
        dio(
          DioExceptionType.unknown,
          error: const SocketException('Failed host lookup'),
        ),
      ),
      ApiError.offline,
    );
  });

  test('every timeout flavour reads as a timeout', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      expect(ApiError.messageOf(dio(type)), ApiError.timeout);
    }
  });

  test('a 422 surfaces the field error, not the generic message', () {
    final error = dio(
      DioExceptionType.badResponse,
      response: body(422, {
        'message': 'The given data was invalid.',
        'errors': {
          'mobile': ['The mobile field is required.'],
        },
      }),
    );

    expect(ApiError.messageOf(error), 'The mobile field is required.');
  });

  test('a 4xx without a validation bag falls back to its message', () {
    final error = dio(
      DioExceptionType.badResponse,
      response: body(400, {'message': 'بيانات الدخول غير صحيحة'}),
    );

    expect(ApiError.messageOf(error), 'بيانات الدخول غير صحيحة');
  });

  test('401 and 403 on an authenticated call read as an expired session', () {
    for (final status in [401, 403]) {
      expect(
        ApiError.messageOf(
          dio(
            DioExceptionType.badResponse,
            response: body(status, null),
            path: 'app/bookings',
          ),
        ),
        ApiError.sessionExpired,
      );
    }
  });

  test('a rejected sign-in is not reported as an expired session', () {
    // Signing in with a wrong password used to read "انتهت الجلسة", which is
    // both untrue and unactionable.
    for (final path in [
      'auth/login',
      'auth/register',
      'auth/forgot-password',
    ]) {
      expect(
        ApiError.messageOf(
          dio(
            DioExceptionType.badResponse,
            response: body(401, null),
            path: path,
          ),
        ),
        ApiError.invalidCredentials,
      );
    }
  });

  test('a rejected sign-in prefers the message the API sent', () {
    expect(
      ApiError.messageOf(
        dio(
          DioExceptionType.badResponse,
          response: body(401, {'message': 'رقم الهاتف غير مسجل'}),
        ),
      ),
      'رقم الهاتف غير مسجل',
    );
  });

  test('a 5xx reads as a server error even with an empty body', () {
    expect(
      ApiError.messageOf(
        dio(DioExceptionType.badResponse, response: body(500, null)),
      ),
      ApiError.server,
    );
  });

  test('a non-Dio throw still yields a renderable key', () {
    expect(ApiError.messageOf(Exception('boom')), ApiError.generic);
    expect(ApiError.messageOf(null), ApiError.generic);
  });
}
