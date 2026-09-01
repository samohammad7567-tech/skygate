import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/models/umrah_document_model.dart';

void main() {
  test('every AuthAssets path exists on disk', () {
    final missing = AuthAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('AuthAssets.all has no duplicates', () {
    expect(AuthAssets.all.toSet().length, AuthAssets.all.length);
  });

  test('pubspec bundles the auth asset folders', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final folder in [
      'assets/images/auth/',
      'assets/images/auth/png/',
      'assets/images/auth/svgs/',
    ]) {
      expect(pubspec, contains('- $folder'), reason: '$folder not bundled');
    }
  });

  test('every document card has a distinct id and a bundled icon', () {
    final documents = UmrahDocumentModel.catalogue;
    expect(documents, hasLength(8));
    expect(documents.map((d) => d.id).toSet(), hasLength(documents.length));
    for (final document in documents) {
      expect(File(document.icon).existsSync(), isTrue, reason: document.icon);
    }
  });

  test('every auth translation key is present in both locales', () {
    final keys = [
      'or',
      'login',
      'create_account',
      'login_title',
      'phone_number',
      'email',
      'password',
      'confirm_password',
      'forgot_password',
      'login_with_phone',
      'login_with_email',
      'reset_link_sent',
      'field_required',
      'invalid_phone',
      'invalid_email',
      'password_too_short',
      'passwords_not_match',
      'must_accept_pledge',
      'file_too_large',
      'personal_info',
      'add_profile_photo',
      'tap_to_upload_photo',
      'pick_from_gallery_or_camera',
      'max_upload_size',
      'choose_from_gallery',
      'take_photo',
      'remove_file',
      'file_uploaded',
      'full_name_triple',
      'passport_info',
      'you_can_use_camera',
      'manual_entry',
      'manual_entry_title',
      'extract_passport_data',
      'scanning_now',
      'mrz_zone',
      'confirm_passport_data',
      'scan_success_title',
      'scan_success_desc',
      'confirm_data_below',
      'select_date',
      'rescan',
      'create_account_action',
      'full_name_ar',
      'full_name_en',
      'full_name_ar_hint',
      'full_name_en_hint',
      'birth_date',
      'gender',
      'male',
      'female',
      'nationality',
      'passport_number',
      'passport_number_hint',
      'national_number',
      'national_number_hint',
      'passport_issue_place',
      'passport_issue_place_hint',
      'issue_date',
      'passport_issue_date',
      'expiry_date',
      'passport_expiry_date',
      'passport_pledge',
      'important_note',
      'important_note_desc',
      'pilgrim_documents',
      'tap_to_upload_file',
      'accepted_criteria',
      'skip_this_step_now',
      'account_created',
      ...UmrahDocumentModel.catalogue.map((d) => d.titleKey),
      ...UmrahDocumentModel.criteriaKeys,
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

  test('password_too_short carries the length placeholder in both locales', () {
    for (final file in ['assets/lang/ar.json', 'assets/lang/en.json']) {
      final json =
          jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>;
      expect(json['password_too_short'] as String, contains('{}'));
    }
  });
}
