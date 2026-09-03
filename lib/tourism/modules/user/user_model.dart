

class UserModel {
  int? id;
  String? full_name;
  String? mobile;
  String? password;
  String? national_number;
  String? dob;
  String? passport_number;
  String? passport_expiry_date;
  String? nationality;
  String? user_id;
  String? status;
  String? fcm_token;
  String? access_token;
  String? lang;
  String? avatar;
  String? gender;
  String? biometrics_key;
  String? biometrics_enabled;
  String? created_at;
  String? updated_at;


  UserModel({this.id,
    this.full_name,
    this.mobile, this.password, this.national_number,
    this.dob, this.passport_number,
    this.passport_expiry_date, this.nationality,
    this.user_id, this.status, this.fcm_token,
    this.access_token, this.lang, this.avatar,
    this.gender,this.biometrics_enabled, this.biometrics_key, this.created_at, this.updated_at});

  factory UserModel.fromJSON(Map<String,dynamic> json) {
    return UserModel(
        id : json["id"] ?? -1,
        full_name : json["full_name"] ?? "",
        mobile : json["mobile"] ?? "",
        password : json["password"] ?? "",
        national_number : json["national_number"] ?? "",
        dob : json["dob"] ?? "",
        passport_number : json["passport_number"] ?? "",
        passport_expiry_date : json["passport_expiry_date"] ?? "",
        nationality : json["nationality"] ?? "",
        user_id : json["user_id"] ?? "",
        status : json["status"] ?? "",
        fcm_token : json["fcm_token"] ?? "",
        access_token : json["access_token"] ?? "",
        lang : json["lang"] ?? "",
        avatar : json["avatar"] ?? "",
        gender : json["gender"] ?? "",
        biometrics_enabled : json["biometrics_enabled"] ?? "",
        biometrics_key: json["biometrics_key"] ?? "",
        created_at : json["created_at"] ?? "",
        updated_at : json["updated_at"] ?? ""
    );
  }

  Map<String,dynamic> toJSON(UserModel model) {
    Map<String,dynamic> user = {};

    user["id"] = model.id;
    user["full_name"] = model.full_name;
    user["mobile"] = model.mobile;
    user["password"] = model.password;
    user["national_number"] = model.national_number;
    user["dob"] = model.dob;
    user["passport_number"] = model.passport_number;
    user["passport_expiry_date"] = model.passport_expiry_date;
    user["nationality"] = model.nationality;
    user["user_id"] = model.user_id;
    user["status"] = model.status;
    user["fcm_token"] = model.fcm_token;
    user["access_token"] = model.access_token;
    user["lang"] = model.lang;
    user["avatar"] = model.avatar;
    user["gender"] = model.gender;
    user["biometrics_enabled"] = model.biometrics_enabled;
    user["biometrics_key"] = model.biometrics_key;
    user["created_at"] = model.created_at;
    user["updated_at"] = model.updated_at;

    return user;
  }
}