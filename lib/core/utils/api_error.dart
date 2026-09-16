import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skygate/core/constants/api_endpoints.dart';

class ApiError {
  ApiError._();
  static const String offline = 'error_no_connection';
  static const String timeout = 'error_timeout';
  static const String certificate = 'error_bad_certificate';
  static const String secureConnection = 'error_secure_connection';
  static const String server = 'error_server';
  static const String sessionExpired = 'error_session_expired';
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
      DioExceptionType.unknown => _fromThrown(error.error),
      DioExceptionType.badResponse => _fromResponse(
        error.response,
        isPublic: ApiEndpoints.isPublicPath(error.requestOptions.path),
      ),
    };
  }

  static String _fromThrown(Object? thrown) {
    if (thrown is SocketException) return offline;
    if (thrown is CertificateException) return certificate;
    if (thrown is! TlsException) return generic;

    return thrown.toString().contains('CERTIFICATE_VERIFY_FAILED')
        ? certificate
        : secureConnection;
  }

  static String _fromResponse(Response? response, {required bool isPublic}) {
    final status = response?.statusCode ?? 0;
    final isRejected = status == 401 || status == 403;
    if (isRejected && !isPublic) return sessionExpired;

    final body = response?.data;
    if (body is Map) {
      final validation = _firstValidationError(body['errors']);
      if (validation != null) return validation;

      final message = body['message']?.toString().trim();
      if (message != null && message.isNotEmpty) return message;
    }
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
