class CityModel {
  int? id;
  String? city;
  String? country;
  String? created_at;
  String? updated_at;

  CityModel({this.id, this.city, this.country, this.created_at, this.updated_at});

  factory CityModel.fromJson(Map<String,dynamic> json) {
    return CityModel(
        id : json["id"] ?? -1,
        city : json["city"] ?? "",
        country : json["country"] ?? "",
        created_at : json["created_at"] ?? "",
        updated_at : json["updated_at"] ?? ""
    );
  }
}