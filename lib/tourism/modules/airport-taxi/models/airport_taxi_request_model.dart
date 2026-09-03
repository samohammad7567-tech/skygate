class AirportTaxiRequestModel {
  int? id;
  String? airport;
  String? home_location;
  String? date;
  String? flight_time;
  String? passengers_number;
  String? user_id;
  String? is_new;
  String? trip_direction;
  String? home_address;
  String? created_at;
  String? updated_at;

  AirportTaxiRequestModel({this.id, this.airport, this.home_location, this.date, this.flight_time, this.passengers_number, this.user_id, this.is_new, this.trip_direction, this.home_address, this.created_at, this.updated_at});

  factory AirportTaxiRequestModel.fromJson(Map<String, dynamic> json) {
    return AirportTaxiRequestModel(
        id : json["id"] ?? -1,
        airport : json["airport"] ?? "",
        home_location : json["home_location"] ?? "",
        date : json["date"] ?? "",
        flight_time : json["flight_time"] ?? "",
        passengers_number : json["passengers_number"] ?? "",
        user_id : json["user_id"] ?? "",
        is_new : json["is_new"] ?? "",
        trip_direction : json["trip_direction"] ?? "",
        home_address : json["home_address"] ?? "",
        created_at : json["created_at"] ?? "",
        updated_at : json["updated_at"] ?? "",
    );
  }
}