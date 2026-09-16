import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/models/time_progress.dart';
import 'package:skygate/core/models/trip_model.dart';

class JourneyRouteModel {
  JourneyRouteModel({this.id, this.name, required this.segments});

  final int? id;
  final String? name;

  final List<JourneySegmentModel> segments;
  factory JourneyRouteModel.fromTrip(TripModel trip) {
    final named = trip.packagesByItinerary;

    return JourneyRouteModel(
      id: named.length == 1 ? named.first.itineraryId : trip.id,
      name: named.length == 1 ? named.first.itineraryName : null,
      segments: [
        for (final leg in trip.itinerary)
          JourneySegmentModel.fromItinerary(leg),
      ],
    );
  }
}

class JourneySegmentModel {
  JourneySegmentModel({
    this.id,
    this.title,
    this.transport = JourneyTransport.plane,
    this.companyName,
    this.tripNumber,
    this.from,
    this.to,
    this.durationMinutes,
    this.vehicle,
    this.departurePlace,
    this.arrivalPlace,
    this.instructions = const [],
  });

  final int? id;
  final String? title;

  final JourneyTransport transport;
  final String? companyName;
  final String? tripNumber;
  final JourneyStopModel? from;
  final JourneyStopModel? to;
  final int? durationMinutes;

  final JourneyVehicleModel? vehicle;
  final JourneyPlaceModel? departurePlace;
  final JourneyPlaceModel? arrivalPlace;
  final List<String> instructions;
  String? get mapImage => null;
  TimeProgress get progress => TimeProgress.fromWindow(from?.at, to?.at);

  factory JourneySegmentModel.fromItinerary(TripItineraryModel leg) {
    final transport = JourneyTransport.fromApi(leg.transportType);
    final carrier = leg.carrier;

    return JourneySegmentModel(
      id: leg.id,
      transport: transport,
      companyName: carrier?.name,
      tripNumber: leg.reference,
      from: JourneyStopModel(at: leg.departureTime, city: leg.originCity),
      to: JourneyStopModel(at: leg.arrivalTime, city: leg.destinationCity),
      durationMinutes: leg.durationMinutes,
      vehicle: JourneyVehicleModel(
        companyName: carrier?.name,
        companyLogo: carrier?.logoUrl,
        model: leg.vehicle?.vehicleType,
        capacity: leg.vehicle?.capacity,
      ),
      departurePlace: JourneyPlaceModel(name: leg.originCity),
      arrivalPlace: JourneyPlaceModel(name: leg.destinationCity),
    );
  }
}

class JourneyStopModel {
  JourneyStopModel({this.at, this.city, this.code, this.place});

  final DateTime? at;
  final String? city;
  final String? code;
  final String? place;
}

class JourneyVehicleModel {
  JourneyVehicleModel({
    this.companyName,
    this.companyLogo,
    this.model,
    this.capacity,
  });

  final String? companyName;
  final String? companyLogo;
  final String? model;
  final int? capacity;
}

class JourneyPlaceModel {
  JourneyPlaceModel({this.name, this.description});

  final String? name;
  final String? description;
}
