import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/app_assets.dart';

void main() {
  test('every AppAssets path exists on disk', () {
    final missing = AppAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('AppAssets.all has no duplicates', () {
    expect(AppAssets.all.toSet().length, AppAssets.all.length);
  });
}
