import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/splash_assets.dart';
import 'package:skygate/features/splash/models/splash_service.dart';

void main() {
  test('there are five splash backgrounds and they exist on disk', () {
    expect(SplashAssets.backgrounds, hasLength(5));
    expect(SplashAssets.all.toSet().length, SplashAssets.all.length);
    final missing = SplashAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('every splash asset sits in a folder pubspec bundles', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in SplashAssets.all) {
      final folder = '${path.substring(0, path.lastIndexOf('/'))}/';
      expect(pubspec, contains('- $folder'), reason: '$path is not bundled');
    }
  });

  test('service cache values round-trip and stay distinct', () {
    final values = SplashService.values.map((s) => s.cacheValue).toList();
    expect(values.toSet().length, values.length);
    for (final service in SplashService.values) {
      expect(SplashService.fromCache(service.cacheValue), service);
    }
    expect(SplashService.fromCache(null), isNull);
    expect(SplashService.fromCache('nope'), isNull);
  });

  test('every splash key is present in both locales', () {
    final keys = [
      'journey_starts_here',
      'or',
      ...SplashService.values.map((s) => s.labelKey),
    ];
    for (final file in ['assets/lang/ar.json', 'assets/lang/en.json']) {
      final json =
          jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>;
      for (final key in keys) {
        expect(
          json.containsKey(key),
          isTrue,
          reason: '$key missing from $file',
        );
        expect(
          (json[key] as String).trim(),
          isNotEmpty,
          reason: '$key empty in $file',
        );
      }
    }
  });
}
