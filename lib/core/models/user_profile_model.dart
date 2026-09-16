import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/utils/api_parse.dart';

class UserProfileModel {
  UserProfileModel({
    this.id,
    this.userId,
    this.fullName,
    this.fullNameEn,
    this.mobile,
    this.email,
    this.nationalNumber,
    this.dateOfBirth,
    this.passportNumber,
    this.passportIssueDate,
    this.passportIssuePlace,
    this.passportExpiryDate,
    this.nationality,
    this.status,
    this.language,
    this.avatar,
    this.gender,
    this.biometricsEnabled = false,
  });
  final int? id;
  final String? userId;

  final String? fullName;
  final String? fullNameEn;

  final String? mobile;
  final String? email;
  final String? nationalNumber;
  final DateTime? dateOfBirth;
  final String? passportNumber;
  final DateTime? passportIssueDate;
  final String? passportIssuePlace;
  final DateTime? passportExpiryDate;
  final String? nationality;
  final String? status;
  final String? language;

  final String? avatar;
  final String? gender;
  final bool biometricsEnabled;

  static UserProfileModel? of(dynamic value) {
    if (value is! Map) return null;

    return UserProfileModel(
      id: ApiParse.intOf(value['id']),
      userId: ApiParse.stringOf(value['user_id']),
      fullName: ApiParse.stringOf(value['full_name']),
      fullNameEn: ApiParse.stringOf(value['full_name_en']),
      mobile: ApiParse.stringOf(value['mobile']),
      email: ApiParse.stringOf(value['email']),
      nationalNumber: ApiParse.stringOf(value['national_number']),
      dateOfBirth: ApiParse.dateOf(value['dob'] ?? value['date_of_birth']),
      passportNumber: ApiParse.stringOf(value['passport_number']),
      passportIssueDate: ApiParse.dateOf(value['passport_issue_date']),
      passportIssuePlace: ApiParse.stringOf(value['passport_issue_place']),
      passportExpiryDate: ApiParse.dateOf(value['passport_expiry_date']),
      nationality: ApiParse.stringOf(value['nationality']),
      status: ApiParse.labelOf(value['status']),
      language: ApiParse.stringOf(value['lang']),
      avatar: ApiParse.stringOf(value['avatar'] ?? value['photo_url']),
      gender: ApiParse.labelOf(value['gender']),
      biometricsEnabled: value['biometrics_enabled'] == true,
    );
  }

  String? get firstName => fullName?.split(' ').first;
  PassportDataModel get passport => PassportDataModel(
    fullNameAr: fullName,
    fullNameEn: fullNameEn,
    birthDate: dateOfBirth,
    gender: gender,
    nationality: nationality,
    nationalNumber: nationalNumber,
    passportNumber: passportNumber,
    issuePlace: passportIssuePlace,
    issueDate: passportIssueDate,
    expiryDate: passportExpiryDate,
  );
  UserProfileModel copyWith({
    String? fullName,
    String? fullNameEn,
    String? mobile,
    String? email,
    String? avatar,
    PassportDataModel? passport,
  }) => UserProfileModel(
    id: id,
    userId: userId,
    fullName: passport?.fullNameAr ?? fullName ?? this.fullName,
    fullNameEn: passport?.fullNameEn ?? fullNameEn ?? this.fullNameEn,
    mobile: mobile ?? this.mobile,
    email: email ?? this.email,
    nationalNumber: passport?.nationalNumber ?? nationalNumber,
    dateOfBirth: passport?.birthDate ?? dateOfBirth,
    passportNumber: passport?.passportNumber ?? passportNumber,
    passportIssueDate: passport?.issueDate ?? passportIssueDate,
    passportIssuePlace: passport?.issuePlace ?? passportIssuePlace,
    passportExpiryDate: passport?.expiryDate ?? passportExpiryDate,
    nationality: passport?.nationality ?? nationality,
    status: status,
    language: language,
    avatar: avatar ?? this.avatar,
    gender: passport?.gender ?? gender,
    biometricsEnabled: biometricsEnabled,
  );
  static Map<String, dynamic> accountJson({
    String? fullName,
    String? mobile,
    String? email,
  }) =>
      <String, dynamic>{'full_name': fullName, 'mobile': mobile, 'email': email}
        ..removeWhere((_, value) => value == null || value == '');
}
