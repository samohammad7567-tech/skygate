import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';

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
  final String slug;
  final String labelKey;
  final String typeIcon;
  final String modelIcon;
  final String fallbackLogo;
  String get routeMap => switch (this) {
    JourneyTransport.plane => MyTripsAssets.routeMapAir,
    JourneyTransport.bus => MyTripsAssets.routeMapLand,
    JourneyTransport.train => MyTripsAssets.routeMapTrain,
    JourneyTransport.ship => MyTripsAssets.routeMapSea,
  };

  static JourneyTransport fromSlug(String? slug) => values.firstWhere(
    (transport) => transport.slug == slug,
    orElse: () => JourneyTransport.plane,
  );
  static JourneyTransport fromApi(String? type) {
    final value = type?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return plane;

    bool has(List<String> words) => words.any(value.contains);

    if (has(['bus', 'coach', 'باص', 'حافل', 'land', 'بري'])) return bus;
    if (has(['train', 'rail', 'قطار'])) return train;
    if (has(['ship', 'boat', 'cruise', 'ferry', 'sea', 'بحر', 'سفين'])) {
      return ship;
    }
    return plane;
  }
}
