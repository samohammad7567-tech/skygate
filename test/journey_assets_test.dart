import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/features/journey_details/models/activity_model.dart';
import 'package:skygate/core/models/journey_transport.dart';

void main() {
  test('every JourneyAssets path exists on disk', () {
    final missing = JourneyAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('JourneyAssets.all has no duplicates', () {
    expect(JourneyAssets.all.toSet().length, JourneyAssets.all.length);
  });

  test('every transport resolves its three glyphs and a logo', () {
    for (final transport in JourneyTransport.values) {
      for (final path in [
        transport.typeIcon,
        transport.modelIcon,
        transport.fallbackLogo,
      ]) {
        expect(File(path).existsSync(), isTrue, reason: 'missing $path');
      }
    }
  });

  test('every activity kind resolves its glyph', () {
    for (final kind in ActivityKind.values) {
      expect(
        File(kind.icon).existsSync(),
        isTrue,
        reason: 'missing ${kind.icon}',
      );
    }
  });

  test('unknown slugs fall back instead of throwing', () {
    expect(JourneyTransport.fromSlug('helicopter'), JourneyTransport.plane);
    expect(JourneyTransport.fromSlug(null), JourneyTransport.plane);
    expect(ActivityKind.fromSlug('picnic'), ActivityKind.rituals);
  });
}
