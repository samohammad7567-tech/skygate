class SubmitBookingRequestParams {
  String? related_user;
  String? is_regular_trip;
  String? regular_trip_id;
  String? departure_place;
  String? arrival_place;
  String? is_one_way;
  String? departure_date;
  String? return_date;
  String? trip_level;
  String? adults_number;
  String? children_number;
  String? status;
  String? total_cost;
  String? currency;
  String? babies_number;
  String? nationality;
  String? payment_method;

  SubmitBookingRequestParams({
    this.related_user,
    this.is_regular_trip,
    this.regular_trip_id,
    this.departure_place,
    this.arrival_place,
    this.is_one_way,
    this.departure_date,
    this.return_date,
    this.trip_level,
    this.adults_number,
    this.children_number,
    this.payment_method,
    this.status,
    this.total_cost,
    this.currency,
    this.babies_number,
    this.nationality,
  });
}
