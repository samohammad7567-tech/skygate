class RefundRequestModel {
    int? id;
    String? user_id;
    String? booking_request_number;
    String? refund_type;
    String? refund_amount;
    String? currency;
    String? cancel_penalty;
    String? plane_missing_penalty;
    String? status;
    String? created_at;
    String? updated_at;

    RefundRequestModel({this.id, this.user_id, this.booking_request_number, this.refund_type, this.refund_amount, this.currency, this.cancel_penalty, this.plane_missing_penalty, this.status, this.created_at, this.updated_at});


    factory RefundRequestModel.fromJson(Map<String,dynamic> json) {
      return RefundRequestModel(
          id: json["id"] ?? -1,
          user_id: json["user_id"] ?? "",
          booking_request_number: json["booking_request_number"] ?? "",
          refund_type: json["refund_type"] ?? "",
          refund_amount: json["refund_amount"] ?? "",
          currency: json["currency"] ?? "",
          cancel_penalty: json["cancel_penalty"] ?? "",
          plane_missing_penalty: json["plane_missing_penalty"] ?? "",
          status: json["status"] ?? "",
          created_at: json["created_at"] ?? "",
          updated_at: json["updated_at"] ?? "",
      );
    }
}