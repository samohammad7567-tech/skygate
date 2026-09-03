class FlightCompanyModel {
  int? id;
  String? name_en;
  String? name_ar;
  String? logo;
  String? created_at;
  String? updated_at;

  FlightCompanyModel({this.id, this.name_en, this.name_ar, this.logo, this.created_at, this.updated_at});

  factory FlightCompanyModel.fromJson(Map<String,dynamic> json) {
    return FlightCompanyModel(
        id : json["id"] ?? -1,
        name_en : json["name_en"] ?? "",
        name_ar : json["name_ar"] ?? "",
        logo : json["logo"] ?? "",
        created_at : json["created_at"] ?? "",
        updated_at : json["updated_at"] ?? ""
    );
  }
}