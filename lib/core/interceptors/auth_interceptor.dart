import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/utils/cache_util.dart';

/// Attaches the cached token to every request and refreshes it once on 401.
///
/// All 401 / refresh handling lives here — never re-implement it in a cubit.
class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = CacheUtil.get(key: 'token') as String?;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final lang = CacheUtil.get(key: 'lang') as String?;
    options.headers['Accept-Language'] = lang ?? 'ar';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains(
      ApiEndpoints.refreshToken,
    );

    if (!isUnauthorized || isRefreshCall || _isRefreshing) {
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
