import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Key/value persistence on top of `SharedPreferences`.
///
/// Deliberately generic: it knows nothing about `UserModel`, `SharedClass` or
/// routes, so any feature can reuse it. Feature specific session mapping
/// belongs in that feature repository, not here.
///
/// Reads never throw on a missing key: they return the supplied fallback.
class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _preferences;

  /// Optional eager initialisation, e.g. from `main()` before `runApp`.
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _prefs async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------- strings

  Future<bool> setString(String key, String value) async =>
      (await _prefs).setString(key, value);

  Future<String> getString(String key, {String fallback = ''}) async =>
      (await _prefs).getString(key) ?? fallback;

  // ------------------------------------------------------------------ bools

  Future<bool> setBool(String key, bool value) async =>
      (await _prefs).setBool(key, value);

  Future<bool> getBool(String key, {bool fallback = false}) async =>
      (await _prefs).getBool(key) ?? fallback;

  // ------------------------------------------------------------------- ints

  Future<bool> setInt(String key, int value) async =>
      (await _prefs).setInt(key, value);

  Future<int> getInt(String key, {int fallback = 0}) async =>
      (await _prefs).getInt(key) ?? fallback;

  // ----------------------------------------------------------------- double

  Future<bool> setDouble(String key, double value) async =>
      (await _prefs).setDouble(key, value);

  Future<double> getDouble(String key, {double fallback = 0}) async =>
      (await _prefs).getDouble(key) ?? fallback;

  // ------------------------------------------------------------ string list

  Future<bool> setStringList(String key, List<String> value) async =>
      (await _prefs).setStringList(key, value);

  Future<List<String>> getStringList(String key) async =>
      (await _prefs).getStringList(key) ?? <String>[];

  // ------------------------------------------------------------------- json

  /// Stores [value] as an encoded JSON string.
  Future<bool> setJson(String key, Object value) async =>
      setString(key, jsonEncode(value));

  /// Returns the decoded JSON stored under [key], or `null` when absent or
  /// unreadable.
  Future<T?> getJson<T>(String key) async {
    final raw = await getString(key);
    if (raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as T;
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------------ admin

  Future<bool> contains(String key) async => (await _prefs).containsKey(key);

  Future<bool> remove(String key) async => (await _prefs).remove(key);

  /// Removes every key in [keys]. Returns `true` when all removals succeeded.
  Future<bool> removeAll(Iterable<String> keys) async {
    var success = true;
    for (final key in keys) {
      success = await remove(key) && success;
    }
    return success;
  }

  Future<bool> clear() async => (await _prefs).clear();

  Future<Set<String>> keys() async => (await _prefs).getKeys();

  /// Drops the cached instance so the next access re-reads from disk.
  Future<void> reload() async {
    await (await _prefs).reload();
  }
}
