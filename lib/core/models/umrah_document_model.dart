import 'package:skygate/core/constants/auth_assets.dart';

class UmrahDocumentModel {
  final String id;
  final String titleKey;
  final String icon;

  const UmrahDocumentModel({
    required this.id,
    required this.titleKey,
    required this.icon,
  });
  static const List<UmrahDocumentModel> catalogue = [
    UmrahDocumentModel(
      id: 'passport_photo',
      titleKey: 'doc_passport_photo',
      icon: AuthAssets.passport,
    ),
    UmrahDocumentModel(
      id: 'personal_photo',
      titleKey: 'doc_personal_photo',
      icon: AuthAssets.personBook,
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
      icon: AuthAssets.idCard,
    ),
  ];
  static const List<String> criteriaKeys = [
    'criteria_background',
    'criteria_look_at_camera',
    'criteria_recent_color',
    'criteria_official_standards',
  ];
}
