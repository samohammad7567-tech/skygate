class SignupParams {
  String? full_name;
  String? mobile;
  String? password;
  String? national_number;
  String? dob;
  String? passport_number;
  String? passport_expiry_date;
  String? nationality;
  String? lang;
  String? gender;
  String? biometricsKey;
  String? biometricsEnabled;

  SignupParams({
    this.full_name,
    this.mobile,
    this.password,
    this.national_number,
    this.dob,
    this.passport_number,
    this.passport_expiry_date,
    this.nationality,
    this.lang,
    this.gender,
    this.biometricsKey,
    this.biometricsEnabled,
  });
}
