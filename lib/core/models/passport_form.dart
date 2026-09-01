import 'package:flutter/widgets.dart';
import 'package:skygate/core/models/passport_data_model.dart';

/// Editing state of the ten passport rows.
///
/// Both wizards that ask for a passport — signup and the booking flow — own one
/// of these and hand it to `PassportFieldsForm`, so the fields, the scan result
/// and the pledge live in exactly one place.
///
/// It holds no `BuildContext` and emits nothing: the cubit that owns it decides
/// when to rebuild.
class PassportForm {
  final TextEditingController fullNameArController = TextEditingController();
  final TextEditingController fullNameEnController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController nationalNumberController =
      TextEditingController();
  final TextEditingController passportNumberController =
      TextEditingController();
  final TextEditingController issuePlaceController = TextEditingController();

  DateTime? birthDate;
  DateTime? issueDate;
  DateTime? expiryDate;

  /// `male` / `female`, as the API expects them.
  String? gender;

  /// "أتعهد بأن بيانات جواز السفر المدخلة صحيحة..." — required by the manual
  /// entry card only.
  bool pledgeAccepted = false;

  /// `true` once the MRZ came back from the scanner, which is what turns the
  /// confirmation screen's green banner on.
  bool isScanned = false;

  /// Fills every row from a scan result.
  void fillFrom(PassportDataModel data) {
    fullNameArController.text = data.fullNameAr ?? '';
    fullNameEnController.text = data.fullNameEn ?? '';
    nationalityController.text = data.nationality ?? '';
    nationalNumberController.text = data.nationalNumber ?? '';
    passportNumberController.text = data.passportNumber ?? '';
    issuePlaceController.text = data.issuePlace ?? '';
    birthDate = data.birthDate;
    issueDate = data.issueDate;
    expiryDate = data.expiryDate;
    gender = data.gender;
  }

  /// The typed rows, ready to be posted.
  PassportDataModel toModel() => PassportDataModel(
    fullNameAr: fullNameArController.text.trim(),
    fullNameEn: fullNameEnController.text.trim(),
    birthDate: birthDate,
    gender: gender,
    nationality: nationalityController.text.trim(),
    nationalNumber: nationalNumberController.text.trim(),
    passportNumber: passportNumberController.text.trim(),
    issuePlace: issuePlaceController.text.trim(),
    issueDate: issueDate,
    expiryDate: expiryDate,
  );

  /// Empties every row, the pledge and the scan flag.
  ///
  /// The group wizard asks for one passport per traveller through the same
  /// form, so it wipes the draft between travellers rather than building a
  /// fresh form each time.
  void clear() {
    fullNameArController.clear();
    fullNameEnController.clear();
    nationalityController.clear();
    nationalNumberController.clear();
    passportNumberController.clear();
    issuePlaceController.clear();
    birthDate = null;
    issueDate = null;
    expiryDate = null;
    gender = null;
    pledgeAccepted = false;
    isScanned = false;
  }

  /// Drops the scan result so the user lands back on an empty scanner.
  void resetScan() => isScanned = false;

  void dispose() {
    fullNameArController.dispose();
    fullNameEnController.dispose();
    nationalityController.dispose();
    nationalNumberController.dispose();
    passportNumberController.dispose();
    issuePlaceController.dispose();
  }
}
