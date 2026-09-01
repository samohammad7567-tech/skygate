/// The MRZ fields shown on "تأكيد بيانات الجواز" and typed on "إدخال يدوي".
class PassportDataModel {
  String? fullNameAr;
  String? fullNameEn;
  DateTime? birthDate;
  String? gender;
  String? nationality;
  String? nationalNumber;
  String? passportNumber;
  String? issuePlace;
  DateTime? issueDate;
  DateTime? expiryDate;

  PassportDataModel({
    this.fullNameAr,
    this.fullNameEn,
    this.birthDate,
    this.gender,
    this.nationality,
    this.nationalNumber,
    this.passportNumber,
    this.issuePlace,
    this.issueDate,
    this.expiryDate,
  });

  PassportDataModel.fromJson(Map<String, dynamic> json) {
    fullNameAr = json['full_name_ar']?.toString();
    fullNameEn = json['full_name_en']?.toString();
    birthDate = _date(json['birth_date']);
    gender = json['gender']?.toString();
    nationality = json['nationality']?.toString();
    nationalNumber = json['national_number']?.toString();
    passportNumber = json['passport_number']?.toString();
    issuePlace = json['issue_place']?.toString();
    issueDate = _date(json['issue_date']);
    expiryDate = _date(json['expiry_date']);
  }

  Map<String, dynamic> toJson() => {
    'full_name_ar': fullNameAr,
    'full_name_en': fullNameEn,
    'birth_date': _iso(birthDate),
    'gender': gender,
    'nationality': nationality,
    'national_number': nationalNumber,
    'passport_number': passportNumber,
    'issue_place': issuePlace,
    'issue_date': _iso(issueDate),
    'expiry_date': _iso(expiryDate),
  };

  /// The rows `POST app/pilgrims` takes for this passport.
  ///
  /// [isSelf] marks the account holder — the pilgrim the booking is made by
  /// rather than one of the travellers added to it. [guardianPilgrimId] is the
  /// adult a child or an infant travels under, and is left out for an adult.
  ///
  /// The backend keys a pilgrim by `full_name`, so the Arabic name wins and
  /// the English one is sent alongside for the screens that print it.
  Map<String, dynamic> toPilgrimJson({
    required bool isSelf,
    int? guardianPilgrimId,
  }) {
    final arabic = fullNameAr?.trim() ?? '';
    final english = fullNameEn?.trim() ?? '';

    return <String, dynamic>{
      'full_name': arabic.isNotEmpty ? arabic : english,
      'full_name_en': english.isEmpty ? null : english,
      'passport_number': passportNumber,
      'passport_expiry_date': _iso(expiryDate),
      'passport_issue_date': _iso(issueDate),
      'passport_issue_place': issuePlace,
      'national_number': nationalNumber,
      'nationality': nationality,
      'date_of_birth': _iso(birthDate),
      'gender': gender,
      'is_self': isSelf,
      'guardian_pilgrim_id': guardianPilgrimId,
    }..removeWhere((_, value) => value == null || value == '');
  }

  static DateTime? _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '');

  static String? _iso(DateTime? value) =>
      value?.toIso8601String().split('T').first;
}
