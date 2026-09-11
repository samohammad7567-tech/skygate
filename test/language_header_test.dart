import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/interceptors/auth_interceptor.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/language_service.dart';
import 'package:skygate/core/utils/cache_util.dart';

/// Every documented path declares `X-localization` and the backend localises
/// `message` off it, so the header has to follow the locale on screen.
///
/// It used to be nailed to `ar`: the interceptor read a cache key nothing ever
/// wrote. These tests pin down that the key is written, that the header picks
/// the change up on the very next request, and that an unset key still falls
/// back to Arabic.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await CacheUtil.init();
    DioService.init();
  });

  /// The header the interceptor would stamp on a request right now.
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
    // Both consumers, not just the interceptor.
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

    // Nothing has called apply() in this "launch" — restore is what has to
    // carry the choice over, before the first frame builds.
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
