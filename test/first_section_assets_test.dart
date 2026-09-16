import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/first_section_assets.dart';

void main() {
  test('every FirstSectionAssets path exists on disk', () {
    final missing = FirstSectionAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('no duplicate paths', () {
    expect(
      FirstSectionAssets.all.toSet().length,
      FirstSectionAssets.all.length,
    );
  });

  test('every first-section asset sits in a folder pubspec bundles', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in FirstSectionAssets.all) {
      final folder = '${path.substring(0, path.lastIndexOf('/'))}/';
      expect(pubspec, contains('- $folder'), reason: '$path is not bundled');
    }
  });
}
