import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/features/map/models/map_feature_model.dart';

void main() {
  test('every MapAssets path exists on disk', () {
    final missing = MapAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('MapAssets.all has no duplicates', () {
    expect(MapAssets.all.toSet().length, MapAssets.all.length);
  });

  test('every map feature resolves its glyph', () {
    final features = [
      ...MapFeatureModel.protocol,
      ...MapFeatureModel.inactive,
      ...MapFeatureModel.stopped,
    ];

    for (final feature in features) {
      expect(
        File(feature.icon).existsSync(),
        isTrue,
        reason: 'missing ${feature.icon}',
      );
    }
  });

  test('every map feature key is translated in both languages', () {
    final keys = [
      for (final feature in [
        ...MapFeatureModel.protocol,
        ...MapFeatureModel.inactive,
        ...MapFeatureModel.stopped,
      ]) ...[feature.titleKey, ?feature.subtitleKey],
    ];

    for (final language in ['ar', 'en']) {
      final translations =
          jsonDecode(File('assets/lang/$language.json').readAsStringSync())
              as Map<String, dynamic>;
      final missing = keys.where((key) => !translations.containsKey(key));
      expect(missing, isEmpty, reason: 'missing $language keys: $missing');
    }
  });
}
