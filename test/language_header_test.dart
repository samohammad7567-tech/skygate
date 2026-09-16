import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/interceptors/auth_interceptor.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/language_service.dart';
import 'package:skygate/core/utils/cache_util.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await CacheUtil.init();
    DioService.init();
  });
  String stampedLanguage() {
    final options = RequestOptions(path: 'app/home');
    AuthInterceptor().onRequest(options, RequestInterceptorHandler());
    return options.headers['X-localization'] as String;
  }

  test('falls back to Arabic while nothing has been chosen', () {
    expect(LanguageService.current, 'ar');
    expect(stampedLanguage(), 'ar');
  });

  test('a switch reaches the next request, not just the widget tree', () async {
    await LanguageService.apply('en');

    expect(CacheUtil.get(key: LanguageService.cacheKey), 'en');
    expect(LanguageService.current, 'en');
    expect(stampedLanguage(), 'en');
    expect(DioService.dio.options.headers['X-localization'], 'en');
    expect(DioService.dio.options.headers['Accept-Language'], 'en');
  });

  test('switching back writes the second change too', () async {
    await LanguageService.apply('en');
    await LanguageService.apply('ar');

    expect(LanguageService.current, 'ar');
    expect(stampedLanguage(), 'ar');
  });

  test('restore replays the persisted choice onto a fresh Dio', () async {
    SharedPreferences.setMockInitialValues({LanguageService.cacheKey: 'en'});
    await CacheUtil.init();
    DioService.init();
    LanguageService.restore();
    expect(DioService.dio.options.headers['X-localization'], 'en');
    expect(stampedLanguage(), 'en');
  });

  test('an empty or unchanged code is not written', () async {
    await LanguageService.apply('  ');
    expect(CacheUtil.get(key: LanguageService.cacheKey), isNull);

    await LanguageService.apply('ar');
    expect(CacheUtil.get(key: LanguageService.cacheKey), isNull);
  });
}
