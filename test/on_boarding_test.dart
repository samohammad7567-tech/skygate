import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/app_assets.dart';
import 'package:skygate/features/on_boarding/models/on_boarding_page_model.dart';

void main() {
  test('there are five onboarding pages, one per illustration', () {
    expect(OnBoardingPageModel.pages, hasLength(5));
    expect(AppAssets.onboarding, hasLength(5));
  });

  test('every onboarding illustration exists on disk', () {
    for (final page in OnBoardingPageModel.pages) {
      expect(File(page.image).existsSync(), isTrue, reason: page.image);
    }
  });

  test('pages reference the illustrations in order', () {
    expect(
      OnBoardingPageModel.pages.map((p) => p.image).toList(),
      AppAssets.onboarding,
    );
  });

  test('every onboarding key is present in both locales', () {
    final keys = [
      for (final page in OnBoardingPageModel.pages) ...[
        page.titleKey,
        page.descriptionKey,
      ],
      'next',
      'skip',
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
          reason: '$key in $file',
        );
      }
    }
  });
}
