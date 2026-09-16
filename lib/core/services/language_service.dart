import '../utils/cache_util.dart';
import 'dio_service.dart';

class LanguageService {
  LanguageService._();
  static const String cacheKey = 'lang';
  static const String fallback = 'ar';
  static String get current {
    final value = CacheUtil.get(key: cacheKey);
    return value is String && value.isNotEmpty ? value : fallback;
  }

  static void restore() => DioService.updateLanguage(current);
  static Future<void> apply(String languageCode) async {
    final code = languageCode.trim();
    if (code.isEmpty || code == current) return;
    await CacheUtil.setString(key: cacheKey, value: code);
    DioService.updateLanguage(code);
  }
}
