import 'dart:convert';

import 'package:skygate/tourism/modules/my-trips-agenda/models/flight_company_model.dart';

class TripModel {
  int? id;
  FlightCompanyModel? flight_company;
  String? departure_city;
  String? arrival_city;
  String? departure_airport;
  String? arrival_airport;
  String? departure_time;
  String? arrival_time;
  String? departure_date;
  String? repeat_start_date;
  String? repeat_end_date;
  List<String>? repeat_days;
  String? trip_duration;
  String? first_way_level;
  String? second_way_level;
  String? trip_number;
  String? first_transit_city;
  String? first_transit_airport;
  String? second_transit_city;
  String? second_transit_airport;
  String? one_way_adult_cost_dollar;
  String? one_way_child_cost_dollar;
  String? one_way_baby_cost_dollar;
  String? one_way_adult_cost_syp;
  String? one_way_child_cost_syp;
  String? one_way_baby_cost_syp;
  String? two_way_adult_cost_dollar;
  String? two_way_child_cost_dollar;
  String? two_way_baby_cost_dollar;
  String? two_way_adult_cost_syp;
  String? two_way_child_cost_syp;
  String? two_way_baby_cost_syp;
  String? one_way_business_adult_cost_dollar;
  String? one_way_business_child_cost_dollar;
  String? one_way_business_baby_cost_dollar;
  String? one_way_business_adult_cost_syp;
  String? one_way_business_child_cost_syp;
  String? one_way_business_baby_cost_syp;
  String? two_way_business_adult_cost_dollar;
  String? two_way_business_child_cost_dollar;
  String? two_way_business_baby_cost_dollar;
  String? two_way_business_adult_cost_syp;
  String? two_way_business_child_cost_syp;
  String? two_way_business_baby_cost_syp;
  String? created_at;
  String? updated_at;

  TripModel({
    this.id,
    this.flight_company,
    this.departure_city,
    this.arrival_city,
    this.departure_airport,
    this.arrival_airport,
    this.departure_time,
    this.repeat_start_date,
    this.repeat_end_date,
    this.repeat_days,
    this.arrival_time,
    this.departure_date,
    this.trip_duration,
    this.first_way_level,
    this.second_way_level,
    this.first_transit_city,
    this.first_transit_airport,
    this.second_transit_city,
    this.second_transit_airport,
    this.one_way_adult_cost_dollar,
    this.one_way_child_cost_dollar,
    this.one_way_baby_cost_dollar,
    this.one_way_adult_cost_syp,
    this.one_way_child_cost_syp,
    this.one_way_baby_cost_syp,
    this.two_way_adult_cost_dollar,
    this.two_way_child_cost_dollar,
    this.two_way_baby_cost_dollar,
    this.two_way_adult_cost_syp,
    this.two_way_child_cost_syp,
    this.two_way_baby_cost_syp,
    this.trip_number,
    this.one_way_business_adult_cost_dollar,
    this.one_way_business_child_cost_dollar,
    this.one_way_business_baby_cost_dollar,
    this.one_way_business_adult_cost_syp,
    this.one_way_business_child_cost_syp,
    this.one_way_business_baby_cost_syp,
    this.two_way_business_adult_cost_dollar,
    this.two_way_business_child_cost_dollar,
    this.two_way_business_baby_cost_dollar,
    this.two_way_business_adult_cost_syp,
    this.two_way_business_child_cost_syp,
    this.two_way_business_baby_cost_syp,
    this.created_at,
    this.updated_at,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    List<String> days = [];
    if (json["repeat_days"] != null) {
      final repeatDays = jsonDecode(json["repeat_days"]);
      repeatDays.forEach((element) {
        days.add(element);
      });
    }
    return TripModel(
      id: json["id"] ?? -1,
      flight_company: (json["flight_company"] != null)
          ? FlightCompanyModel.fromJson(json["flight_company"])
          : FlightCompanyModel(),
      departure_city: json["departure_city"] ?? "",
      arrival_city: json["arrival_city"] ?? "",
      departure_airport: json["departure_airport"] ?? "",
      arrival_airport: json["arrival_airport"] ?? "",
      departure_time: json["departure_time"] ?? "",
      arrival_time: json["arrival_time"] ?? "",
      departure_date: json["departure_date"] ?? "",
      repeat_start_date: json["repeat_start_date"] ?? "",
      repeat_end_date: json["repeat_end_date"] ?? "",
      repeat_days: days,
      trip_duration: json["trip_duration"] ?? "",
      first_way_level: json["first_way_level"] ?? "",
      second_way_level: json["second_way_level"] ?? "",
      trip_number: json["trip_number"] ?? "",
      first_transit_city: json["first_transit_city"] ?? "",
      first_transit_airport: json["first_transit_airport"] ?? "",
      second_transit_city: json["second_transit_city"] ?? "",
      second_transit_airport: json["second_transit_airport"] ?? "",
      one_way_adult_cost_dollar: json["one_way_adult_cost_dollar"] ?? "0",
      one_way_child_cost_dollar: json["one_way_child_cost_dollar"] ?? "0",
      one_way_baby_cost_dollar: json["one_way_baby_cost_dollar"] ?? "0",
      one_way_adult_cost_syp: json["one_way_adult_cost_syp"] ?? "0",
      one_way_child_cost_syp: json["one_way_child_cost_syp"] ?? "0",
      one_way_baby_cost_syp: json["one_way_baby_cost_syp"] ?? "0",
      two_way_adult_cost_dollar: json["two_way_adult_cost_dollar"] ?? "0",
      two_way_child_cost_dollar: json["two_way_child_cost_dollar"] ?? "0",
      two_way_baby_cost_dollar: json["two_way_baby_cost_dollar"] ?? "0",
      two_way_adult_cost_syp: json["two_way_adult_cost_syp"] ?? "0",
      two_way_child_cost_syp: json["two_way_child_cost_syp"] ?? "0",
      two_way_baby_cost_syp: json["two_way_baby_cost_syp"] ?? "0",
      one_way_business_adult_cost_dollar:
          json["one_way_business_adult_cost_dollar"] ?? "0",
      one_way_business_child_cost_dollar:
          json["one_way_business_child_cost_dollar"] ?? "0",
      one_way_business_baby_cost_dollar:
          json["one_way_business_baby_cost_dollar"] ?? "0",
      one_way_business_adult_cost_syp:
          json["one_way_business_adult_cost_syp"] ?? "0",
      one_way_business_child_cost_syp:
          json["one_way_business_child_cost_syp"] ?? "0",
      one_way_business_baby_cost_syp:
          json["one_way_business_baby_cost_syp"] ?? "0",
      two_way_business_adult_cost_dollar:
          json["two_way_business_adult_cost_dollar"] ?? "0",
      two_way_business_child_cost_dollar:
          json["two_way_business_child_cost_dollar"] ?? "0",
      two_way_business_baby_cost_dollar:
          json["two_way_business_baby_cost_dollar"] ?? "0",
      two_way_business_adult_cost_syp:
          json["two_way_business_adult_cost_syp"] ?? "0",
      two_way_business_child_cost_syp:
          json["two_way_business_child_cost_syp"] ?? "0",
      two_way_business_baby_cost_syp:
          json["two_way_business_baby_cost_syp"] ?? "0",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
