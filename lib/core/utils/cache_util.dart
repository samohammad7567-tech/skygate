import 'package:shared_preferences/shared_preferences.dart';

/// Thin SharedPreferences wrapper. Call it from cubits and services only —
/// never from a widget `build`.
class CacheUtil {
  CacheUtil._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static dynamic get({required String key}) => _prefs.get(key);

  static Future<bool> setString({required String key, required String value}) =>
      _prefs.setString(key, value);

  static Future<bool> setBool({required String key, required bool value}) =>
      _prefs.setBool(key, value);

  static Future<bool> setInt({required String key, required int value}) =>
      _prefs.setInt(key, value);

  static Future<bool> remove({required String key}) => _prefs.remove(key);

  static Future<bool> clear() => _prefs.clear();
}
