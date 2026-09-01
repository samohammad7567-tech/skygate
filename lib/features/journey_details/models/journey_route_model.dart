import 'package:skygate/core/models/journey_transport.dart';
import 'package:skygate/core/models/trip_model.dart';

/// One tab of "مسارات الرحلة" — an ordered list of legs.
///
/// `GET app/trips/{id}` publishes a single flat `itinerary[]` rather than
/// alternative routes to choose between, so a trip yields exactly one tab
/// today. The screens keep their tab row because it costs nothing and starts
/// working the moment the backend groups legs into routes.
class JourneyRouteModel {
  JourneyRouteModel({this.id, this.name, required this.segments});

  final int? id;

  /// The route's own name. Null falls back to "المسار الأول" on the tab.
  final String? name;

  final List<JourneySegmentModel> segments;

  /// The trip's itinerary as the one route it currently is.
  factory JourneyRouteModel.fromTrip(TripModel trip) => JourneyRouteModel(
    id: trip.id,
    segments: [
      for (final leg in trip.itinerary) JourneySegmentModel.fromItinerary(leg),
    ],
  );
}

/// One leg (قسم) of a route: the itinerary card, and the whole of the
/// "تفاصيل القسم" screen.
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

  /// Null falls back to "القسم الأول" from the card's position.
  final String? title;

  final JourneyTransport transport;
  final String? companyName;
  final String? tripNumber;
  final JourneyStopModel? from;
  final JourneyStopModel? to;

  /// Length of the leg; rendered as "مدة الرحلة: 2س 15د".
  final int? durationMinutes;

  final JourneyVehicleModel? vehicle;
  final JourneyPlaceModel? departurePlace;
  final JourneyPlaceModel? arrivalPlace;

  /// Bullets of the "تعليمات مهمة" card. The trip endpoint carries none, so
  /// the card hides itself until it does.
  final List<String> instructions;

  /// Route map printed under the two location sections. Bundled artwork until
  /// the API ships one.
  String? get mapImage => null;

  /// One leg of `itinerary[]`.
  ///
  /// The endpoint names the carrier, the two cities and the two times; the
  /// terminal, the vehicle model and the location write-ups the design also
  /// shows are not published, so those rows fall back to their placeholders.
  factory JourneySegmentModel.fromItinerary(TripItineraryModel leg) {
    final transport = JourneyTransport.fromApi(leg.segmentType);

    return JourneySegmentModel(
      id: leg.id,
      transport: transport,
      companyName: leg.carrier,
      from: JourneyStopModel(at: leg.departureTime, city: leg.originCity),
      to: JourneyStopModel(at: leg.arrivalTime, city: leg.destinationCity),
      durationMinutes: leg.durationMinutes,
      vehicle: JourneyVehicleModel(companyName: leg.carrier),
      departurePlace: JourneyPlaceModel(name: leg.originCity),
      arrivalPlace: JourneyPlaceModel(name: leg.destinationCity),
    );
  }
}

/// One end of a leg — the time, city and terminal printed either side of the
/// dashed arrow.
class JourneyStopModel {
  JourneyStopModel({this.at, this.city, this.code, this.place});

  final DateTime? at;
  final String? city;

  /// IATA-style code shown next to the city, e.g. `JED`.
  final String? code;

  /// Terminal or station, e.g. "مطار الملك عبدالعزيز - صالة 1".
  final String? place;
}

/// The "تفاصيل المركبة" block: carrier plus the three spec tiles.
class JourneyVehicleModel {
  JourneyVehicleModel({
    this.companyName,
    this.companyLogo,
    this.model,
    this.capacity,
  });

  final String? companyName;
  final String? companyLogo;

  /// Free text for the "طراز المركبة" tile, e.g. `Boeing 737`.
  final String? model;

  /// Seat count for the "سعة المركبة" tile.
  final int? capacity;
}

/// Title plus the descriptive paragraph of a departure/arrival location.
class JourneyPlaceModel {
  JourneyPlaceModel({this.name, this.description});

  final String? name;
  final String? description;
}
