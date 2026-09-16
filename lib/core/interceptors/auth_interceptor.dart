import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/language_service.dart';
import 'package:skygate/core/utils/cache_util.dart';

class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = CacheUtil.get(key: 'token') as String?;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final lang = LanguageService.current;
    options.headers['Accept-Language'] = lang;
    options.headers['X-localization'] = lang;
    options.headers[Headers.acceptHeader] = Headers.jsonContentType;
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isPublic = ApiEndpoints.isPublicPath(err.requestOptions.path);
    final token = CacheUtil.get(key: 'token') as String?;
    final hasSession = token != null && token.isNotEmpty;

    if (!isUnauthorized || isPublic || !hasSession || _isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        await _clearSession();
        return handler.next(err);
      }
      final retried =
          await Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl)).fetch(
            err.requestOptions
              ..headers['Authorization'] =
                  'Bearer ${CacheUtil.get(key: 'token')}',
          );
      return handler.resolve(retried);
    } catch (error) {
      debugPrint('AuthInterceptor refresh error: $error');
      await _clearSession();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = CacheUtil.get(key: 'refresh_token') as String?;
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final response = await Dio(
      BaseOptions(baseUrl: ApiEndpoints.baseUrl),
    ).post(ApiEndpoints.refreshToken, data: {'refresh_token': refreshToken});
    final token = response.data['data']?['token'] as String?;
    if (token == null) return false;

    await CacheUtil.setString(key: 'token', value: token);
    return true;
  }

  Future<void> _clearSession() async {
    await CacheUtil.remove(key: 'token');
    await CacheUtil.remove(key: 'refresh_token');
    await CacheUtil.setBool(key: 'isGuest', value: true);
  }
}
