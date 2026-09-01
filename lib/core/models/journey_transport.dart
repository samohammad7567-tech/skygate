import 'package:skygate/core/constants/journey_assets.dart';

/// Mode of transport for one leg (قسم) of a route.
///
/// The three "تفاصيل المركبة" tiles and the itinerary rail all pick their
/// glyph from here, so a new transport type only has to be added once.
enum JourneyTransport {
  plane(
    'plane',
    'transport_plane',
    JourneyAssets.plane,
    JourneyAssets.planeModel,
    JourneyAssets.airlineLogo,
  ),
  bus(
    'bus',
    'transport_bus',
    JourneyAssets.bus,
    JourneyAssets.busModel,
    JourneyAssets.transportLogo,
  ),
  train(
    'train',
    'transport_train',
    JourneyAssets.train,
    JourneyAssets.trainModel,
    JourneyAssets.railwayLogo,
  ),
  ship(
    'ship',
    'transport_ship',
    JourneyAssets.ship,
    JourneyAssets.shipModel,
    JourneyAssets.transportLogo,
  );

  const JourneyTransport(
    this.slug,
    this.labelKey,
    this.typeIcon,
    this.modelIcon,
    this.fallbackLogo,
  );

  /// Value sent by the API under `transport`.
  final String slug;
  final String labelKey;

  /// Glyph for the "نوع المركبة" tile and the itinerary rail dot.
  final String typeIcon;

  /// Glyph for the "طراز المركبة" tile.
  final String modelIcon;

  /// Carrier logo used until the API returns one.
  final String fallbackLogo;

  static JourneyTransport fromSlug(String? slug) => values.firstWhere(
    (transport) => transport.slug == slug,
    orElse: () => JourneyTransport.plane,
  );

  /// Resolves `TripItineraryResource.segment_type`, which names the mode in
  /// the backend's own words (`flight`, `coach`, `cruise`, "طيران" …) rather
  /// than in the four slugs above.
  static JourneyTransport fromApi(String? type) {
    final value = type?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return plane;

    bool has(List<String> words) => words.any(value.contains);

    if (has(['bus', 'coach', 'باص', 'حافل'])) return bus;
    if (has(['train', 'rail', 'قطار'])) return train;
    if (has(['ship', 'boat', 'cruise', 'ferry', 'sea', 'بحر', 'سفين'])) {
      return ship;
    }
    return plane;
  }
}
