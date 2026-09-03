class PassportModel {
  final String firstName;
  final String lastName;
  final String nationalNumber;
  final String dateOfBirth;
  final String passportNumber;
  final String passportExpiryDate;
  final String nationality;
  final String gender;
  // When passports come as files from backend, this will be filled.
  // Example JSON: {"file_url": "/storage/passports/agDHYwiWOaBSZgZpOoyJivNCE3b1aCiHhQW5vSey.jpg"}
  final String fileUrl;

  PassportModel({
    required this.firstName,
    required this.lastName,
    required this.nationalNumber,
    required this.dateOfBirth,
    required this.passportNumber,
    required this.passportExpiryDate,
    required this.nationality,
    required this.gender,
    this.fileUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'nationalNumber': nationalNumber,
      'dateOfBirth': dateOfBirth,
      'passportNumber': passportNumber,
      'passportExpiryDate': passportExpiryDate,
      'nationality': nationality,
      'gender': gender,
      'file_url': fileUrl,
    };
  }

  factory PassportModel.fromMap(Map<String, dynamic> map) {
    return PassportModel(
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      nationalNumber: map['nationalNumber'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      passportNumber: map['passportNumber'] ?? '',
      passportExpiryDate: map['passportExpiryDate'] ?? '',
      nationality: map['nationality'] ?? '',
      gender: map['gender'] ?? '',
      fileUrl: map['file_url'] ?? '',
    );
  }

  factory PassportModel.fromJson(Map<String, dynamic> json) {
    return PassportModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      nationalNumber: json['national_number'] ?? json['nationalNumber'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? json['dateOfBirth'] ?? '',
      passportNumber: json['passport_number'] ?? json['passportNumber'] ?? '',
      passportExpiryDate:
          json['passport_expiry_date'] ?? json['passportExpiryDate'] ?? '',
      nationality: json['nationality'] ?? '',
      gender: json['gender'] ?? '',
      fileUrl: json['file_url'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PassportModel(firstName: $firstName, lastName: $lastName, nationalNumber: $nationalNumber, dateOfBirth: $dateOfBirth, passportNumber: $passportNumber, passportExpiryDate: $passportExpiryDate, nationality: $nationality, gender: $gender, fileUrl: $fileUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PassportModel &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.nationalNumber == nationalNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.passportNumber == passportNumber &&
        other.passportExpiryDate == passportExpiryDate &&
        other.nationality == nationality &&
        other.gender == gender &&
        other.fileUrl == fileUrl;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        nationalNumber.hashCode ^
        dateOfBirth.hashCode ^
        passportNumber.hashCode ^
        passportExpiryDate.hashCode ^
        nationality.hashCode ^
        gender.hashCode ^
        fileUrl.hashCode;
  }
}
