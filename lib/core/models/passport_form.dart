import 'package:flutter/widgets.dart';
import 'package:skygate/core/models/passport_data_model.dart';

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
  String? gender;
  bool pledgeAccepted = false;
  bool isScanned = false;
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
