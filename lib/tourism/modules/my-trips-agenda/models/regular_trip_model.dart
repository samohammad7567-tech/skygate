import 'package:skygate/tourism/modules/my-trips-agenda/models/trip_model.dart';

class RegularTripModel {
  List<TripModel>? first_way_trips;
  List<TripModel>? return_trips;

  RegularTripModel({this.first_way_trips, this.return_trips});

  factory RegularTripModel.fromJson(Map<String, dynamic> json) {
    List<TripModel>? onePathTrips = [];
    List<TripModel>? doublePathTrips = [];
    if(json["first_way_trips"] != null) {
      json["first_way_trips"].forEach((element) {
        onePathTrips.add(TripModel.fromJson(element));
      });
    }

    if(json["return_trips"] != null) {
      json["return_trips"].forEach((element) {
        doublePathTrips.add(TripModel.fromJson(element));
      });
    }
    return RegularTripModel(
        first_way_trips : onePathTrips,
        return_trips : doublePathTrips
    );
  }
}