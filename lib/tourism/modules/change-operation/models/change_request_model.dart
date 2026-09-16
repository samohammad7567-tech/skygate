class ChangeRequestModel {
  int? id;
  String? user_id;
  String? booking_request_number;
  String? change_type;
  String? first_way_trip_id;
  String? return_trip_id;
  String? change_penalty;
  String? cost_difference;
  String? plane_missing_penalty;
  String? currency;
  String? status;
  String? payment_method;
  String? is_paid;
  String? created_at;
  String? updated_at;

  ChangeRequestModel({
    this.id,
    this.user_id,
    this.booking_request_number,
    this.change_type,
    this.first_way_trip_id,
    this.return_trip_id,
    this.change_penalty,
    this.cost_difference,
    this.plane_missing_penalty,
    this.currency,
    this.status,
    this.created_at,
    this.updated_at,
    this.payment_method,
    this.is_paid,
  });

  factory ChangeRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangeRequestModel(
      id: json["id"] ?? -1,
      user_id: json["user_id"] ?? "",
      booking_request_number: json["booking_request_number"] ?? "",
      change_type: json["change_type"] ?? "",
      first_way_trip_id: json["first_way_trip_id"] ?? "",
      return_trip_id: json["return_trip_id"] ?? "",
      change_penalty: json["change_penalty"] ?? "",
      cost_difference: json["cost_difference"] ?? "",
      plane_missing_penalty: json["plane_missing_penalty"] ?? "",
      currency: json["currency"] ?? "",
      status: json["status"] ?? "",
      payment_method: json["payment_method"] ?? "",
      is_paid: json["is_paid"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
