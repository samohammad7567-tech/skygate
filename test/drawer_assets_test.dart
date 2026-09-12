import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/drawer_assets.dart';
import 'package:skygate/features/main/models/drawer_item_model.dart';
import 'package:skygate/features/main/models/nav_item_model.dart';

void main() {
  test('every DrawerAssets path exists on disk', () {
    final missing = DrawerAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('DrawerAssets.all has no duplicates', () {
    expect(DrawerAssets.all.toSet().length, DrawerAssets.all.length);
  });

  test('every drawer asset sits in a folder pubspec bundles', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in DrawerAssets.all) {
      final folder = '${path.substring(0, path.lastIndexOf('/'))}/';
      expect(pubspec, contains('- $folder'), reason: '$path is not bundled');
    }
  });

  test('the drawer has eleven rows across three groups', () {
    final sections = DrawerSectionModel.catalogue;
    expect(sections, hasLength(3));
    expect(sections.first.titleKey, isNull);
    expect(sections.skip(1).every((s) => s.titleKey != null), isTrue);
    expect(sections.expand((s) => s.items), hasLength(11));
  });

  test('every drawer row has a bundled icon and a distinct label', () {
    final items = DrawerSectionModel.catalogue
        .expand((section) => section.items)
        .toList();
    for (final item in items) {
      expect(File(item.icon).existsSync(), isTrue, reason: item.icon);
    }
    expect(items.map((i) => i.labelKey).toSet(), hasLength(items.length));
  });

  /// A tab row that points past the end of the bottom bar would switch to a
  /// destination that does not exist.
  test('every tab row points at a real bottom-nav destination', () {
    final tabs = DrawerSectionModel.catalogue
        .expand((section) => section.items)
        .where((item) => item.isTab)
        .toList();

    // الإعدادات is drawn with الدعم rather than with its siblings, so the
    // tab rows are not contiguous.
    expect(tabs.map((i) => i.tabIndex), [0, 1, 2, 3, 4]);
    for (final tab in tabs) {
      expect(tab.tabIndex, lessThan(NavItemModel.items.length));
      expect(tab.labelKey, NavItemModel.items[tab.tabIndex!].labelKey);
    }
  });

  test('every drawer translation key is present in both locales', () {
    final keys = [
      'logout',
      'logout_question',
      'yes',
      'no',
      'coming_soon',
      ...DrawerSectionModel.catalogue.map((s) => s.titleKey).nonNulls,
      ...DrawerSectionModel.catalogue
          .expand((s) => s.items)
          .map((i) => i.labelKey),
    ];

    // The bundled JSON is the source; codegen_loader.g.dart is what the app
    // actually loads, so a key added to one and not the other ships as a raw
    // key on screen.
    final generated = File(
      'lib/generated/codegen_loader.g.dart',
    ).readAsStringSync();

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
        expect(
          generated,
          contains('"$key"'),
          reason: '$key missing from codegen_loader.g.dart',
        );
      }
    }
  });
}
