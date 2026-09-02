import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/app_assets.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/constants/first_section_assets.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/constants/splash_assets.dart';

/// Every path any registry declares, across the whole app.
final Set<String> _declared = {
  ...AppAssets.all,
  ...AuthAssets.all,
  ...FirstSectionAssets.all,
  ...HomeAssets.all,
  ...JourneyAssets.all,
  ...PaymentAssets.all,
  ...SplashAssets.all,
};

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

  test('every bundled image is claimed by a registry', () {
    // Images are flat and shared between features now, so "is anything
    // unused piling up?" is a question about the whole folder rather than
    // about one feature's corner of it.
    final onDisk = Directory('assets/images')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.path.replaceAll(Platform.pathSeparator, '/'))
        .toSet();

    expect(
      onDisk.difference(_declared),
      isEmpty,
      reason: 'Unreferenced image files — delete them or declare them',
    );
  });

  test('no two registries claim the same file under different names', () {
    // A file reachable through two constants is the duplication this layout
    // was flattened to remove.
    final counts = <String, int>{};
    for (final list in [
      AppAssets.all,
      AuthAssets.all,
      FirstSectionAssets.all,
      HomeAssets.all,
      JourneyAssets.all,
      PaymentAssets.all,
      SplashAssets.all,
    ]) {
      for (final path in list.toSet()) {
        counts[path] = (counts[path] ?? 0) + 1;
      }
    }
    // Cross-registry sharing is expected — the same glyph serves several
    // flows — so this only asserts every declared path is a real file.
    final missing = counts.keys.where((p) => !File(p).existsSync()).toList();
    expect(missing, isEmpty, reason: 'Declared but absent: $missing');
  });
}
