import 'package:skygate/core/constants/auth_assets.dart';

/// One card on the "ملفات المعتمر" step: an icon, a title key and the file the
/// user attached to it.
class UmrahDocumentModel {
  /// Sent to the API as the document discriminator.
  final String id;

  /// Translation key for the card title.
  final String titleKey;

  /// Bundled SVG shown in the round badge.
  final String icon;

  const UmrahDocumentModel({
    required this.id,
    required this.titleKey,
    required this.icon,
  });

  /// Fixed design content, in the order the cards appear in the mockup.
  static const List<UmrahDocumentModel> catalogue = [
    UmrahDocumentModel(
      id: 'passport_photo',
      titleKey: 'doc_passport_photo',
      icon: AuthAssets.passport,
    ),
    UmrahDocumentModel(
      id: 'personal_photo',
      titleKey: 'doc_personal_photo',
      icon: AuthAssets.accountCircle,
    ),
    UmrahDocumentModel(
      id: 'mahram_marriage_contract',
      titleKey: 'doc_mahram_marriage',
      icon: AuthAssets.familyRestroom,
    ),
    UmrahDocumentModel(
      id: 'vaccination',
      titleKey: 'doc_vaccination',
      icon: AuthAssets.vaccines,
    ),
    UmrahDocumentModel(
      id: 'family_book',
      titleKey: 'doc_family_book',
      icon: AuthAssets.familyGroup,
    ),
    UmrahDocumentModel(
      id: 'no_criminal_record',
      titleKey: 'doc_no_criminal_record',
      icon: AuthAssets.localPolice,
    ),
    UmrahDocumentModel(
      id: 'family_statement',
      titleKey: 'doc_family_statement',
      icon: AuthAssets.menuBook,
    ),
    UmrahDocumentModel(
      id: 'personal_id',
      titleKey: 'doc_personal_id',
      icon: AuthAssets.personBook,
    ),
  ];

  /// The four bullets under "شروط و المعايير المقبولة:" — identical on every
  /// card in the design.
  static const List<String> criteriaKeys = [
    'criteria_background',
    'criteria_look_at_camera',
    'criteria_recent_color',
    'criteria_official_standards',
  ];
}
