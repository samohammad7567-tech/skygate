class AirportModel {
  int? id;
  String? name;
  String? iata_code;
  SkygateLocation? location;
  String? city;
  String? created_at;
  String? updated_at;

  AirportModel({
    this.id,
    this.name,
    this.iata_code,
    this.location,
    this.city,
    this.created_at,
    this.updated_at,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json["id"] ?? -1,
      name: json["name"] ?? "",
      iata_code: json["iata_code"] ?? "",
      location: (json["location"] != null)
          ? SkygateLocation.formJson(json["location"])
          : SkygateLocation(),
      city: json["city"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}

class SkygateLocation {
  String? type;
  List<double>? coordinates;

  SkygateLocation({this.type, this.coordinates});

  factory SkygateLocation.formJson(Map<String, dynamic> json) {
    List<double> returnedCoord = [];
    if (json["coordinates"] != null) {
      json["coordinates"].forEach((element) {
        returnedCoord.add(element);
      });
    }
    return SkygateLocation(
      type: json["type"] ?? "",
      coordinates: returnedCoord,
    );
  }
}
