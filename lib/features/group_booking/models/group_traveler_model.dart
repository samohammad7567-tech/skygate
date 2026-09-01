import 'dart:io';

import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/features/group_booking/models/traveler_audience.dart';

/// One pilgrim in "تكوين المجموعة": their passport, the files attached to it,
/// and the adult answering for them when they are a child or an infant.
class GroupTravelerModel {
  GroupTravelerModel({
    required this.localId,
    required this.passport,
    required this.documents,
    this.guardianLocalId,
  });

  /// Identity inside the wizard, handed out by the cubit. The traveller has no
  /// backend id until the booking is submitted.
  final int localId;

  final PassportDataModel passport;

  /// Attached files per `UmrahDocumentModel.id`.
  final Map<String, File> documents;

  /// [localId] of the adult this traveller travels under, or `null` for an
  /// adult.
  int? guardianLocalId;

  /// Backend id, filled in by `POST app/pilgrims` when the booking is created.
  int? pilgrimId;

  /// Read off the passport rather than asked for.
  TravelerAudience get audience =>
      TravelerAudience.fromBirthDate(passport.birthDate);

  /// The name printed on the card, Arabic first as the design shows it.
  String get name {
    final arabic = passport.fullNameAr?.trim() ?? '';
    if (arabic.isNotEmpty) return arabic;
    return passport.fullNameEn?.trim() ?? '';
  }

  /// The rows `POST app/pilgrims` takes for this traveller.
  ///
  /// [isSelf] marks the group leader, who is the account holder, and
  /// [guardianPilgrimId] the adult a child or an infant travels under — the
  /// id the guardian was given when their own record was created a moment
  /// earlier.
  Map<String, dynamic> toPilgrimJson({
    required bool isSelf,
    int? guardianPilgrimId,
  }) => passport.toPilgrimJson(
    isSelf: isSelf,
    guardianPilgrimId: guardianPilgrimId,
  );
}
