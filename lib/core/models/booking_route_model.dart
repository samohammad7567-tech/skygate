import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/models/trip_model.dart';

class BookingRouteModel {
  BookingRouteModel({this.id, this.title, this.name, this.legs = const []});

  final int? id;
  final String? title;
  final String? name;

  final List<BookingRouteLegModel> legs;
  factory BookingRouteModel.fromTrip(TripModel trip) => BookingRouteModel(
    id: trip.id,
    legs: [
      for (final leg in trip.itinerary)
        BookingRouteLegModel(
          transport: JourneyTransport.fromApi(leg.segmentType),
          from: leg.originCity,
          to: leg.destinationCity,
        ),
    ],
  );
}

class BookingRouteLegModel {
  BookingRouteLegModel({
    this.transport = JourneyTransport.plane,
    this.from,
    this.to,
  });

  final JourneyTransport transport;
  final String? from;
  final String? to;
}
