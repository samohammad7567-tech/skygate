import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/features/home/models/offer_model.dart';
import 'package:skygate/features/home/models/service_model.dart';
import 'package:skygate/features/home/models/travel_category_model.dart';
import 'package:skygate/features/main/models/nav_item_model.dart';

void main() {
  test('every HomeAssets path exists on disk', () {
    final missing = HomeAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('HomeAssets.all has no duplicates', () {
    expect(HomeAssets.all.toSet().length, HomeAssets.all.length);
  });

  test('every home asset sits in a folder pubspec bundles', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in HomeAssets.all) {
      final folder = '${path.substring(0, path.lastIndexOf('/'))}/';
      expect(pubspec, contains('- $folder'), reason: '$path is not bundled');
    }
  });

  test(
    'the services grid has nine tiles with distinct ids and bundled art',
    () {
      final services = ServiceModel.catalogue;
      expect(services, hasLength(9));
      expect(services.map((s) => s.id).toSet(), hasLength(services.length));
      for (final service in services) {
        expect(File(service.image).existsSync(), isTrue, reason: service.image);
        final overlay = service.overlay;
        if (overlay != null) {
          expect(File(overlay).existsSync(), isTrue, reason: overlay);
        }
      }
    },
  );

  test('only the VIP tile carries a banner overlay', () {
    final withOverlay = ServiceModel.catalogue
        .where((s) => s.overlay != null)
        .map((s) => s.id);
    expect(withOverlay, ['vip_trips']);
  });

  test('every category pill and nav destination has a bundled icon', () {
    for (final category in TravelCategoryModel.catalogue) {
      expect(File(category.icon).existsSync(), isTrue, reason: category.icon);
    }
    for (final item in NavItemModel.items) {
      expect(File(item.icon).existsSync(), isTrue, reason: item.icon);
    }
  });

  test('every offer inclusion slug resolves to a bundled glyph', () {
    for (final slug in OfferInclusion.defaultOrder) {
      final asset = OfferInclusion.assetFor(slug);
      expect(asset, isNotNull, reason: slug);
      expect(File(asset!).existsSync(), isTrue, reason: asset);
    }
  });

  test('every home translation key is present in both locales', () {
    final keys = [
      'menu',
      'notifications',
      'travel_date',
      'choose_umrah_trip_date',
      'search',
      'current_offers',
      'view_all',
      'no_offers',
      'retry',
      'departure',
      'return_date',
      'days_count',
      'starts_from',
      'currency',
      'view_details',
      'what_our_services_include',
      'every_offer_includes_services',
      'design_your_own_trip',
      'design_your_own_trip_desc',
      'feature_custom_trip',
      'feature_flexible_dates',
      'feature_direct_contact',
      'we_send_approval_soon',
      'request_your_trip',
      'vip',
      'something_went_wrong',
      ...TravelCategoryModel.catalogue.map((c) => c.titleKey),
      ...ServiceModel.catalogue.map((s) => s.titleKey),
      ...ServiceModel.catalogue.map((s) => s.descriptionKey),
      ...NavItemModel.items.map((i) => i.labelKey),
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
