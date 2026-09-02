import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skygate/core/constants/api_endpoints.dart';

/// Turns whatever a failed request threw into one line the UI can show.
///
/// Every cubit routes its `catchError` through here, so error copy is written
/// once. The result is either a message the API sent — already localised by
/// the `Accept-Language` header — or one of the translation keys below, which
/// the UI passes through `.tr()`.
class ApiError {
  ApiError._();

  /// Keys returned when the failure never reached the API.
  static const String offline = 'error_no_connection';
  static const String timeout = 'error_timeout';
  static const String certificate = 'error_bad_certificate';
  static const String server = 'error_server';
  static const String sessionExpired = 'error_session_expired';

  /// A 401 from a public auth endpoint — the credentials were wrong. Only used
  /// when the API sent no message of its own to show instead.
  static const String invalidCredentials = 'error_invalid_credentials';

  static const String generic = 'something_went_wrong';

  static String messageOf(Object? error) {
    if (error is! DioException) return generic;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => timeout,
      DioExceptionType.badCertificate => certificate,
      DioExceptionType.connectionError => offline,
      DioExceptionType.cancel => generic,
      DioExceptionType.unknown =>
        error.error is SocketException ? offline : generic,
      DioExceptionType.badResponse => _fromResponse(
        error.response,
        // Signing in is not a session that ran out, so a 401 here must not be
        // reported as one.
        isPublic: ApiEndpoints.isPublicPath(error.requestOptions.path),
      ),
    };
  }

  /// Reads the body of a 4xx/5xx. Laravel answers a failed validation with an
  /// `errors` bag keyed by field, which is far more useful than its generic
  /// `message`, so that wins when both are present.
  ///
  /// [isPublic] marks a call made without a session — signing in, registering,
  /// resetting a password. There the API's own message is the useful one, and a
  /// 401 is a rejected credential rather than an expired session.
  static String _fromResponse(Response? response, {required bool isPublic}) {
    final status = response?.statusCode ?? 0;
    final isRejected = status == 401 || status == 403;

    // On an authenticated call a 401 means the token is no longer good, and
    // Laravel's own copy for it ("Unauthenticated.") is no use to the pilgrim.
    if (isRejected && !isPublic) return sessionExpired;

    final body = response?.data;
    if (body is Map) {
      final validation = _firstValidationError(body['errors']);
      if (validation != null) return validation;

      final message = body['message']?.toString().trim();
      if (message != null && message.isNotEmpty) return message;
    }

    // A sign-in the backend turned down without saying why.
    if (isRejected) return invalidCredentials;

    return status >= 500 ? server : generic;
  }

  static String? _firstValidationError(dynamic errors) {
    if (errors is! Map) return null;

    for (final value in errors.values) {
      final first = value is List
          ? (value.isEmpty ? null : value.first)
          : value;
      final text = first?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }
}
