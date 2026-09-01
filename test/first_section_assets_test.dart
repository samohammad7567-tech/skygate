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

  test('every file on disk is declared in FirstSectionAssets', () {
    final onDisk = Directory('assets/images/firstsection')
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path.replaceAll(r'\', '/'))
        .toSet();
    final declared = FirstSectionAssets.all.toSet();
    expect(onDisk.difference(declared), isEmpty);
  });
}
