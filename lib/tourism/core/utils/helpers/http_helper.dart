import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:skygate/tourism/modules/language/language_controller.dart';
import '../../../data/model/base_response/base_response.dart';
import '../failures/http/http_failure.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final languageController = Get.find<LanguageController>();

class HttpHelper {
  HttpHelper();

  late final StreamController<HttpFailure> errorStreamController =
      StreamController<HttpFailure>();

  bool hasListener() {
    return errorStreamController.hasListener;
  }

  Stream<HttpFailure> listenForErrors() {
    return errorStreamController.stream;
  }

  Future<BaseResponse<T>> get<T>(
    String url, {
    T Function(dynamic json)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async {
    try {
      log('request for $url');
      log('with headers $headers');
      log('with Params $params');
      final response = await http
          .get(Uri.parse(_getUrlWithParams(url, params)), headers: headers)
          .timeout(const Duration(seconds: 60));
      log('response from $url with status code ${response.statusCode}');
      log('response date ${response.body}');
      final ret = _responseHandler<T>(response, decoder);

      log('with Data ${ret.toString()}');
      return ret;
    } on SocketException catch (_) {
      HttpFailure failure = const NoInternetConnection();
      errorStreamController.add(failure);
      throw failure;
    } on http.ClientException catch (_) {
      HttpFailure failure = const NoInternetConnection();
      errorStreamController.add(failure);
      throw failure;
    } on TimeoutException catch (_) {
      HttpFailure failure = const TimeOutFailure();
      errorStreamController.add(failure);
      throw failure;
    }
  }

  Future<BaseResponse<T>> post<T>(
    String url, {
    body = const <dynamic, dynamic>{},
    T Function(dynamic json)? decoder,
    Map<String, String>? headers = const {},
    Map<String, dynamic>? params,
  }) async {
    try {
      if (headers!.isEmpty) {
        headers = HttpHelper.basicHeader;
      }
      log('request for  ${_getUrlWithParams(url, params)}');
      log('with headers $headers');
      log('with Params $params');
      log('with body  $body');
      final response = await http
          .post(
            Uri.parse(_getUrlWithParams(url, params)),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 60));
      log('response from $url with status code ${response.statusCode}');
      log('response data ${response.body}');
      final ret = _responseHandler<T>(response, decoder);

      log('with Data ${ret.data.runtimeType}');
      return ret;
    } on SocketException catch (_) {
      HttpFailure failure = const NoInternetConnection();
      errorStreamController.add(failure);
      throw failure;
    } on http.ClientException catch (_) {
      HttpFailure failure = const NoInternetConnection();
      errorStreamController.add(failure);
      throw failure;
    } on TimeoutException catch (_) {
      HttpFailure failure = const TimeOutFailure();
      errorStreamController.add(failure);
      throw failure;
    }
  }

  Future<BaseResponse<T>> postMultipart<T>(
    String url, {
    Map<String, String>? fields,
    Map<String, List<File>>? files,
    T Function(dynamic json)? decoder,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async {
    try {
      headers ??= HttpHelper.basicHeader;

      log('multipart request for  ${_getUrlWithParams(url, params)}');
      log('with headers $headers');
      log('with Params $params');
      log('with fields  $fields');
      log(
        'with files  ${files?.map((key, value) => MapEntry(key, value.length))}',
      );

      final uri = Uri.parse(_getUrlWithParams(url, params));
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(headers);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        for (final entry in files.entries) {
          final fieldName = entry.key;
          for (final file in entry.value) {
            final fileName = file.path.split(Platform.pathSeparator).last;
            final length = await file.length();
            final stream = http.ByteStream(file.openRead());

            request.files.add(
              http.MultipartFile(
                fieldName, // e.g. "passports_files"
                stream,
                length,
                filename: fileName,
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(streamedResponse);

      log('response from $url with status code ${response.statusCode}');
      log('response data ${response.body}');

      final ret = _responseHandler<T>(response, decoder);
      log('with Data ${ret.data.runtimeType}');
      return ret;
    } on SocketException catch (_) {
      HttpFailure failure = const NoInternetConnection();
      errorStreamController.add(failure);
      throw failure;
    } on http.ClientException catch (_) {
      HttpFailure failure = const NoInternetConnection();
      errorStreamController.add(failure);
      throw failure;
    } on TimeoutException catch (_) {
      HttpFailure failure = const TimeOutFailure();
      errorStreamController.add(failure);
      throw failure;
    }
  }

  String _getUrlWithParams(String url, Map<String, dynamic>? params) {
    if (params != null) {
      url += '?';
      final listOfParam = params.entries.toList();
      for (int i = 0; i < listOfParam.length; i++) {
        url += '${listOfParam[i].key}=${listOfParam[i].value.toString()}';
        if (i + 1 < listOfParam.length) {
          url += '&';
        }
      }
    }
    return url;
  }

  BaseResponse<T> _responseHandler<T>(
    http.Response response,
    T Function(dynamic json)? decoder,
  ) {
    int statusCode = getStatusCode(response);
    log("From Response Handler statusCode = $statusCode");
    HttpFailure failure;
    if ((statusCode == 1) || (statusCode == -15000)) {
      return BaseResponse.fromJson(jsonDecode(response.body), decoder);
    } else if (statusCode == HttpStatus.unauthorized ||
        statusCode == HttpStatus.forbidden) {
      failure = const UnauthorizedFailure();
    } else if (statusCode == HttpStatus.internalServerError) {
      failure = const ServerFailure();
    } else if (statusCode == 405) {
      failure = const MethodNotAllowedFailure();
    } else if (statusCode == -24) {
      failure = const NotVerifiedFailure();
    } else {
      String errorMessage = 'Unknown Error!';
      try {
        errorMessage = BaseResponse.fromJson(
          jsonDecode(response.body),
          null,
        ).message!;
      } catch (_) {}
      failure = CustomFailure(message: errorMessage);
    }
    errorStreamController.add(failure);
    throw failure;
  }

  static int getStatusCode(http.Response response) {
    int httpStatus = response.statusCode;
    if (httpStatus == 200) {
      try {
        final code = BaseResponse.fromJson(
          jsonDecode(response.body),
          null,
        ).code;
        return int.tryParse(code ?? '') ?? httpStatus;
      } catch (_) {
        return httpStatus;
      }
    } else {
      return httpStatus;
    }
  }

  static Map<String, String> basicHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-localization': (languageController.appLanguage == "en") ? "en" : "ar",
  };

  static Map<String, String> basicHeaderWithToken(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'X-localization': (languageController.appLanguage == "en") ? "en" : "ar",
  };

  static Map<String, String> basicHeaderWithLanguage(String? langCode) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-localization': langCode!,
  };
}
