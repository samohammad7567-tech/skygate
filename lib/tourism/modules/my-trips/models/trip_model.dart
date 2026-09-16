import 'dart:convert';
import 'package:skygate/tourism/modules/my-trips/models/condition_model.dart';

class TripModel {
  int? id;
  String? passenger_name;
  String? reservation_number;
  String? ticket_number;
  String? trip_attend_time;
  String? trip_departure_time;
  String? trip_arrival_time;
  String? trip_date;
  String? trip_duration;
  String? departure_place;
  String? arrival_place;
  String? transit_departure_place;
  String? transit_arrival_place;
  String? plane_allowed_weight;
  String? handbag_allowed_weight;
  String? flight_company;
  String? babies;
  String? file;
  String? notes;
  ConditionModel? conditions;
  String? conditions_accepted;
  List<String> get filesList {
    if (file == null || file!.isEmpty) {
      return [];
    }
    try {
      final decoded = json.decode(file!);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  TripModel({
    this.passenger_name,
    this.reservation_number,
    this.ticket_number,
    this.trip_attend_time,
    this.trip_departure_time,
    this.trip_arrival_time,
    this.trip_date,
    this.trip_duration,
    this.departure_place,
    this.arrival_place,
    this.transit_departure_place,
    this.transit_arrival_place,
    this.plane_allowed_weight,
    this.handbag_allowed_weight,
    this.flight_company,
    this.babies,
    this.file,
    this.id,
    this.conditions,
    this.notes,
    this.conditions_accepted,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json["id"] ?? -1,
      passenger_name: json['passenger_name'] as String?,
      reservation_number: json['reservation_number'] as String?,
      ticket_number: json['ticket_number'] as String?,
      trip_attend_time: json['trip_attend_time'] as String?,
      trip_departure_time: json['trip_departure_time'] as String?,
      trip_arrival_time: json['trip_arrival_time'] as String?,
      trip_date: json['trip_date'] as String?,
      trip_duration: json['trip_duration'] as String?,
      departure_place: json['departure_place'] as String?,
      arrival_place: json['arrival_place'] as String?,
      transit_departure_place: json['transit_departure_place'] as String?,
      transit_arrival_place: json['transit_arrival_place'] as String?,
      plane_allowed_weight: json['plane_allowed_weight'] as String?,
      handbag_allowed_weight: json['handbag_allowed_weight'] as String?,
      flight_company: json['flight_company'] as String?,
      babies: json['babies'] as String?,
      file: json['file'] as String?,
      notes: json['notes'] ?? "",
      conditions: (json['conditions'] != null)
          ? ConditionModel.fromJson(json['conditions'])
          : ConditionModel(),
      conditions_accepted: json['conditions_accepted'] ?? "0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passenger_name': passenger_name,
      'reservation_number': reservation_number,
      'ticket_number': ticket_number,
      'trip_attend_time': trip_attend_time,
      'trip_departure_time': trip_departure_time,
      'trip_arrival_time': trip_arrival_time,
      'trip_date': trip_date,
      'trip_duration': trip_duration,
      'departure_place': departure_place,
      'arrival_place': arrival_place,
      'transit_departure_place': transit_departure_place,
      'transit_arrival_place': transit_arrival_place,
      'plane_allowed_weight': plane_allowed_weight,
      'handbag_allowed_weight': handbag_allowed_weight,
      'flight_company': flight_company,
      'babies': babies,
      'file': file,
      'notes': notes,
      'conditions': conditions,
      'conditions_accepted': conditions_accepted,
    };
  }
}
