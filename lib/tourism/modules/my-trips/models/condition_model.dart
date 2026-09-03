class ConditionModel {
  int? id;
  String? edit_booking;
  String? missing_flight;
  String? amount_refund_with_cancel;
  String? missing_after_cancel;
  String? first_item_cost;
  String? second_item_cost;
  String? third_item_cost;
  String? fourth_item_cost;
  String? currency;
  String? slug;
  String? created_at;
  String? updated_at;

  ConditionModel({this.id, this.edit_booking, this.missing_flight, this.amount_refund_with_cancel, this.missing_after_cancel, this.first_item_cost, this.second_item_cost, this.third_item_cost, this.fourth_item_cost, this.currency, this.slug, this.created_at, this.updated_at});

  factory ConditionModel.fromJson(Map<String,dynamic> json) {
      return ConditionModel(
          id: json["id"] ?? -1,
          edit_booking: json["edit_booking"] ?? "",
          missing_flight: json["missing_flight"] ?? "",
          amount_refund_with_cancel: json["amount_refund_with_cancel"] ?? "",
          missing_after_cancel: json["missing_after_cancel"] ?? "",
          first_item_cost: json["first_item_cost"] ?? "",
          second_item_cost: json["second_item_cost"] ?? "",
          third_item_cost: json["third_item_cost"] ?? "",
          fourth_item_cost: json["fourth_item_cost"] ?? "",
          currency: json["currency"] ?? "",
          slug: json["slug"] ?? "",
          created_at: json["created_at"] ?? "",
          updated_at: json["updated_at"] ?? "",
      );
  }
}