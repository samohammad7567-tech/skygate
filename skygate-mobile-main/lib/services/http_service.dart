import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app/core/utils/failures/http/http_failure.dart';
import '../app/data/model/base_response/base_response.dart';

/// Framework neutral HTTP client.
///
/// Wraps `package:http` and maps every response onto [BaseResponse] or a
/// [HttpFailure]. Failures are also pushed on [errors] so a global listener can
/// react once (e.g. logging the user out on [UnauthorizedFailure]).
///
/// The service has no knowledge of GetX / Bloc. The `X-localization` header is
/// resolved through [languageCodeProvider], which the app sets once at startup:
///
/// ```dart
/// HttpService.instance.languageCodeProvider = () => languageController.appLanguage;
/// ```
class HttpService {
  HttpService._();

  static final HttpService instance = HttpService._();

  /// Timeout applied to every request.
  Duration timeout = const Duration(seconds: 60);

  /// Resolves the current app language for the `X-localization` header.
  /// Defaults to Arabic, the app primary language.
  String Function() languageCodeProvider = () => 'ar';

  final StreamController<HttpFailure> _errorController =
      StreamController<HttpFailure>.broadcast();

  /// Broadcast stream of every failure produced by this service.
  Stream<HttpFailure> get errors => _errorController.stream;

  bool get hasListener => _errorController.hasListener;

  Map<String, String> get basicHeader => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-localization': languageCodeProvider(),
      };

  Map<String, String> basicHeaderWithToken(String token) => {
        ...basicHeader,
        'Authorization': 'Bearer $token',
      };

  Map<String, String> basicHeaderWithLanguage(String langCode) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-localization': langCode,
      };

  Future<BaseResponse<T>> get<T>(
    String url, {
    T Function(dynamic json)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async {
    final target = _urlWithParams(url, params);
    try {
      headers ??= basicHeader;
      log('GET $target');
      log('headers $headers');

      final response =
          await http.get(Uri.parse(target), headers: headers).timeout(timeout);

      log('GET $target -> ${response.statusCode}');
      log('body ${response.body}');
      return _handleResponse<T>(response, decoder);
    } on SocketException catch (_) {
      throw _emit(const NoInternetConnection());
    } on http.ClientException catch (_) {
      throw _emit(const NoInternetConnection());
    } on TimeoutException catch (_) {
      throw _emit(const TimeOutFailure());
    }
  }

  Future<BaseResponse<T>> post<T>(
    String url, {
    dynamic body = const <dynamic, dynamic>{},
    T Function(dynamic json)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async {
    final target = _urlWithParams(url, params);
    try {
      if (headers == null || headers.isEmpty) {
        headers = basicHeader;
      }
      log('POST $target');
      log('headers $headers');
      log('body $body');

      final response = await http
          .post(Uri.parse(target), headers: headers, body: jsonEncode(body))
          .timeout(timeout);

      log('POST $target -> ${response.statusCode}');
      log('body ${response.body}');
      return _handleResponse<T>(response, decoder);
    } on SocketException catch (_) {
      throw _emit(const NoInternetConnection());
    } on http.ClientException catch (_) {
      throw _emit(const NoInternetConnection());
    } on TimeoutException catch (_) {
      throw _emit(const TimeOutFailure());
    }
  }

  /// Multipart POST for endpoints expecting `multipart/form-data`
  /// (passport images, PDF attachments, avatars...).
  ///
  /// [files] maps a field name to the files attached under it, e.g.
  /// `{ 'passports_files': [file1, file2] }`.
  Future<BaseResponse<T>> postMultipart<T>(
    String url, {
    Map<String, String>? fields,
    Map<String, List<File>>? files,
    T Function(dynamic json)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async {
    final target = _urlWithParams(url, params);
    try {
      headers ??= basicHeader;
      log('MULTIPART POST $target');
      log('headers $headers');
      log('fields $fields');
      log('files ${files?.map((key, value) => MapEntry(key, value.length))}');

      final request = http.MultipartRequest('POST', Uri.parse(target));
      request.headers.addAll(headers);
      if (fields != null) request.fields.addAll(fields);

      if (files != null) {
        for (final entry in files.entries) {
          for (final file in entry.value) {
            request.files.add(
              http.MultipartFile(
                entry.key,
                http.ByteStream(file.openRead()),
                await file.length(),
                filename: file.path.split(Platform.pathSeparator).last,
              ),
            );
          }
        }
      }

      final streamed = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamed);

      log('MULTIPART POST $target -> ${response.statusCode}');
      log('body ${response.body}');
      return _handleResponse<T>(response, decoder);
    } on SocketException catch (_) {
      throw _emit(const NoInternetConnection());
    } on http.ClientException catch (_) {
      throw _emit(const NoInternetConnection());
    } on TimeoutException catch (_) {
      throw _emit(const TimeOutFailure());
    }
  }

  /// The backend answers `200` with a business code inside the payload, so the
  /// effective status is the inner `code` whenever the transport succeeded.
  static int statusCodeOf(http.Response response) {
    if (response.statusCode == 200) {
      return int.parse(
        BaseResponse.fromJson(jsonDecode(response.body), null).code!,
      );
    }
    return response.statusCode;
  }

  BaseResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic json)? decoder,
  ) {
    final statusCode = statusCodeOf(response);
    log('resolved status code $statusCode');

    if (statusCode == 1 || statusCode == -15000) {
      return BaseResponse.fromJson(jsonDecode(response.body), decoder);
    }

    final HttpFailure failure;
    if (statusCode == HttpStatus.unauthorized ||
        statusCode == HttpStatus.forbidden) {
      failure = const UnauthorizedFailure();
    } else if (statusCode == HttpStatus.internalServerError) {
      failure = const ServerFailure();
    } else if (statusCode == HttpStatus.methodNotAllowed) {
      failure = const MethodNotAllowedFailure();
    } else if (statusCode == -24) {
      failure = const NotVerifiedFailure();
    } else {
      var message = 'Unknown Error!';
      try {
        message =
            BaseResponse.fromJson(jsonDecode(response.body), null).message ??
                message;
      } catch (_) {
        // keep the fallback message
      }
      failure = CustomFailure(message: message);
    }

    throw _emit(failure);
  }

  HttpFailure _emit(HttpFailure failure) {
    _errorController.add(failure);
    return failure;
  }

  String _urlWithParams(String url, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return url;
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$url?$query';
  }

  Future<void> dispose() => _errorController.close();
}
