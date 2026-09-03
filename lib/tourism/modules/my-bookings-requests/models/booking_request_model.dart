import 'dart:convert';

import 'package:skygate/tourism/modules/my-bookings-requests/models/request_reply_model.dart';
import 'package:skygate/tourism/modules/my-trips/models/condition_model.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/passport_model.dart';

class BookingRequestModel {
  int? id;
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
  String? request_number;
  ConditionModel? first_way_conditions;
  ConditionModel? return_conditions;
  RequestReplyModel? replies;
  String? is_paid;
  String? travel_notes;
  String? conditions_accepted;
  List<PassportModel>? passports;
  String? created_at;
  String? updated_at;

  BookingRequestModel(
      {this.id,
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
      this.status,
      this.total_cost,
      this.currency,
      this.babies_number,
      this.nationality,
      this.payment_method,
      this.request_number,
      this.first_way_conditions,
      this.return_conditions,
      this.replies,
      this.is_paid,
      this.travel_notes,
      this.conditions_accepted,
      this.passports,
      this.created_at,
      this.updated_at});

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
        id: json["id"] ?? -1,
        related_user: json["related_user"] ?? "",
        is_regular_trip: json["is_regular_trip"] ?? "",
        regular_trip_id: json["regular_trip_id"] ?? "",
        departure_place: json["departure_place"] ?? "",
        arrival_place: json["arrival_place"] ?? "",
        is_one_way: json["is_one_way"] ?? "",
        departure_date: json["departure_date"] ?? "",
        return_date: json["return_date"] ?? "",
        trip_level: json["trip_level"] ?? "",
        adults_number: json["adults_number"] ?? "",
        children_number: json["children_number"] ?? "",
        status: json["status"] ?? "",
        total_cost: json["total_cost"] ?? "",
        currency: json["currency"] ?? "",
        babies_number: json["babies_number"] ?? "",
        nationality: json["nationality"] ?? "",
        payment_method: json["payment_method"] ?? "",
        request_number: json["request_number"] ?? "",
        first_way_conditions: (json["first_way_conditions"] != null)
            ? ConditionModel.fromJson(json["first_way_conditions"])
            : ConditionModel(),
        return_conditions: (json["return_conditions"] != null)
            ? ConditionModel.fromJson(json["return_conditions"])
            : ConditionModel(),
        replies: (json["replies"] != null)
            ? RequestReplyModel.fromJson(json["replies"])
            : RequestReplyModel(),
        is_paid: json["is_paid"] ?? "",
        travel_notes: json["travel_notes"] ?? "",
        conditions_accepted: json["conditions_accepted"] ?? "",
        passports: (json["passports"] != null)
            ? (jsonDecode(json["passports"]) as List)
                .map((passportJson) => PassportModel.fromJson(passportJson))
                .toList()
            : [],
        created_at: json["created_at"] ?? "",
        updated_at: json["updated_at"] ?? "");
  }
}
