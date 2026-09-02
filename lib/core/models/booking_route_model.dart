import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/models/trip_model.dart';

/// One selectable card on "اختر المسار".
///
/// `GET app/trips/{id}` publishes a single flat `itinerary[]` rather than
/// alternative routes, so the step shows the trip's one route and the card
/// starts already ticked. The list stays a list so the screen keeps working
/// unchanged once the backend offers a choice.
class BookingRouteModel {
  BookingRouteModel({this.id, this.title, this.name, this.legs = const []});

  final int? id;

  /// Ordinal caption above the name, e.g. "المسار الأول:". Null falls back to
  /// the card's position.
  final String? title;

  /// The route's own name, e.g. "المسار الجوي مروراً بجدة".
  final String? name;

  final List<BookingRouteLegModel> legs;

  /// The trip's itinerary as the one route it currently is.
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

/// One row of a route card: the transport glyph, then the two city names
/// either side of the dashed arrow.
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
