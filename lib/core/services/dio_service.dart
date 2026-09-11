import 'package:dio/dio.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/interceptors/auth_interceptor.dart';

class DioService {
  DioService._();

  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // Laravel branches on `Accept` — without it the API is free to answer
        // a browser: `auth/login` redirects instead of returning the session,
        // which reached Dio as a 302 it refuses to follow on a POST. Set here
        // so no call can go out without it. `Content-Type` is left to Dio's
        // ImplyContentTypeInterceptor, which sends JSON for a Map body and
        // still switches to `multipart/form-data` for the FormData uploads.
        headers: const {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(AuthInterceptor());
  }

  static void updateToken(String? token) {
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static void updateLanguage(String languageCode) {
    dio.options.headers['X-localization'] = languageCode;
    dio.options.headers['Accept-Language'] = languageCode;
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => dio.get(path, queryParameters: queryParameters);

  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) => dio.post(path, data: data, queryParameters: queryParameters);

  static Future<Response> put(String path, {dynamic data}) =>
      dio.put(path, data: data);

  static Future<Response> delete(String path, {dynamic data}) =>
      dio.delete(path, data: data);
}
