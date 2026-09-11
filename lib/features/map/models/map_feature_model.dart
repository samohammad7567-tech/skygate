import 'package:skygate/core/constants/map_assets.dart';

class MapFeatureModel {
  const MapFeatureModel({
    required this.icon,
    required this.titleKey,
    this.subtitleKey,
  });

  final String icon;
  final String titleKey;
  final String? subtitleKey;
  static const List<MapFeatureModel> protocol = [
    MapFeatureModel(
      icon: MapAssets.instantAlerts,
      titleKey: 'map_feature_instant_alerts',
    ),
    MapFeatureModel(
      icon: MapAssets.movementLog,
      titleKey: 'map_feature_movement_log',
    ),
    MapFeatureModel(icon: MapAssets.shield, titleKey: 'map_feature_no_fines'),
  ];
  static const List<MapFeatureModel> inactive = [
    MapFeatureModel(
      icon: MapAssets.shield,
      titleKey: 'map_inactive_safety_title',
      subtitleKey: 'map_inactive_safety_desc',
    ),
    MapFeatureModel(
      icon: MapAssets.documents,
      titleKey: 'map_inactive_log_title',
      subtitleKey: 'map_inactive_log_desc',
    ),
    MapFeatureModel(
      icon: MapAssets.bell,
      titleKey: 'map_inactive_alerts_title',
      subtitleKey: 'map_inactive_alerts_desc',
    ),
  ];
  static const List<MapFeatureModel> stopped = [
    MapFeatureModel(
      icon: MapAssets.tripDone,
      titleKey: 'map_stopped_trip_title',
      subtitleKey: 'map_stopped_trip_desc',
    ),
    MapFeatureModel(
      icon: MapAssets.chart,
      titleKey: 'map_stopped_log_title',
      subtitleKey: 'map_stopped_log_desc',
    ),
    MapFeatureModel(
      icon: MapAssets.shield,
      titleKey: 'map_stopped_privacy_title',
      subtitleKey: 'map_stopped_privacy_desc',
    ),
  ];
}
