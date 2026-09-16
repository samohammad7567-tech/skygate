import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/features/profile/models/document_type_model.dart';
import 'package:skygate/features/profile/models/pilgrim_document_model.dart';

void main() {
  test('every ProfileAssets path exists on disk', () {
    final missing = ProfileAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('ProfileAssets.all has no duplicates', () {
    expect(ProfileAssets.all.toSet().length, ProfileAssets.all.length);
  });

  test('every profile asset sits in a folder pubspec bundles', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in ProfileAssets.all) {
      final folder = '${path.substring(0, path.lastIndexOf('/'))}/';
      expect(pubspec, contains('- $folder'), reason: '$path is not bundled');
    }
  });
  test('an unknown review status falls back to pending', () {
    expect(DocumentReviewStatus.of(null), DocumentReviewStatus.pending);
    expect(DocumentReviewStatus.of(''), DocumentReviewStatus.pending);
    expect(
      DocumentReviewStatus.of('under_review'),
      DocumentReviewStatus.pending,
    );
    expect(DocumentReviewStatus.of('APPROVED'), DocumentReviewStatus.approved);
    expect(
      DocumentReviewStatus.of(' rejected '),
      DocumentReviewStatus.rejected,
    );
  });
  test('PilgrimDocumentModel reads either shape of status', () {
    final asList = PilgrimDocumentModel.fromJson(const {
      'id': 1,
      'document_type_id': 4,
      'status': ['approved'],
      'file_url': 'pilgrim-documents/a.png',
    });
    expect(asList.review, DocumentReviewStatus.approved);
    expect(asList.hasFile, isTrue);

    final asString = PilgrimDocumentModel.fromJson(const {
      'id': 2,
      'status': 'rejected',
      'rejection_reason': 'الصورة غير واضحة',
    });
    expect(asString.review, DocumentReviewStatus.rejected);
    expect(asString.hasFile, isFalse);
  });
  test('document types match their card whatever the slug spelling', () {
    final types = [
      DocumentTypeModel.fromJson(const {'id': 7, 'code': 'Personal-Photo'}),
      DocumentTypeModel.fromJson(const {'id': 9, 'slug': 'passport_photo'}),
    ];
    final catalogue = UmrahDocumentModel.catalogue;
    final personal = catalogue.firstWhere((d) => d.id == 'personal_photo');
    final passport = catalogue.firstWhere((d) => d.id == 'passport_photo');
    final vaccination = catalogue.firstWhere((d) => d.id == 'vaccination');

    expect(DocumentTypeModel.idOf(types, personal), 7);
    expect(DocumentTypeModel.idOf(types, passport), 9);
    expect(DocumentTypeModel.idOf(types, vaccination), isNull);
  });

  test('every profile translation key is present in both locales', () {
    final keys = [
      'nav_account',
      'profile_information',
      'username',
      'phone_number',
      'email',
      'passport_information',
      'files',
      'pilgrim_files',
      'pilgrim_file',
      'account_management',
      'password',
      'edit_password',
      'current_password',
      'new_password_label',
      'confirm_new_password_label',
      'password_changed',
      'edit_account',
      'edit_account_information',
      'account_saved',
      'logout',
      'passport_full_name_ar',
      'passport_full_name_en',
      'edit_passport_information',
      'passport_saved',
      'you_can_rescan',
      'you_can_rescan_or_type',
      'scan_success_title',
      'scan_success_desc',
      'scan_failed_title',
      'scan_failed_desc',
      'preview',
      'edit_pilgrim_files',
      'edit_files',
      'files_saved',
      'no_file_uploaded',
      'file_preview_failed',
      'back',
      'save_changes',
      'cancel',
      for (final status in DocumentReviewStatus.values) status.labelKey,
      for (final document in UmrahDocumentModel.catalogue) document.titleKey,
    ];
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
