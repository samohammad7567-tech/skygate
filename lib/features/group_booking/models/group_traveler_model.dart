import 'dart:io';

import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/models/traveler_audience.dart';

class GroupTravelerModel {
  GroupTravelerModel({
    required this.localId,
    required this.passport,
    required this.documents,
    this.guardianLocalId,
  });
  final int localId;

  final PassportDataModel passport;
  final Map<String, File> documents;
  int? guardianLocalId;
  int? pilgrimId;
  TravelerAudience get audience =>
      TravelerAudience.fromBirthDate(passport.birthDate);
  String get name {
    final arabic = passport.fullNameAr?.trim() ?? '';
    if (arabic.isNotEmpty) return arabic;
    return passport.fullNameEn?.trim() ?? '';
  }

  Map<String, dynamic> toPilgrimJson({
    required bool isSelf,
    int? guardianPilgrimId,
  }) => passport.toPilgrimJson(
    isSelf: isSelf,
    guardianPilgrimId: guardianPilgrimId,
  );
}
