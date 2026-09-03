class SearchTripsParams {
  String? departure_city;
  String? arrival_city;
  String? departure_date;
  String? return_date;
  String? is_round_trip;

  SearchTripsParams({this.departure_city, this.arrival_city, this.departure_date, this.return_date, this.is_round_trip});
}