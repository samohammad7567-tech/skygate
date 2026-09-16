import 'package:skygate/core/constants/app_assets.dart';
import 'package:skygate/core/constants/home_assets.dart';

class ServiceModel {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String image;
  final String? overlay;

  const ServiceModel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.image,
    this.overlay,
  });

  ServiceModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      titleKey = json['title'] ?? '',
      descriptionKey = json['description'] ?? '',
      image = json['image'] ?? AppAssets.placeholder,
      overlay = json['overlay'];
  static const List<ServiceModel> catalogue = [
    ServiceModel(
      id: 'tracking',
      titleKey: 'service_tracking_title',
      descriptionKey: 'service_tracking_desc',
      image: HomeAssets.servicePilgrimTracking,
    ),
    ServiceModel(
      id: 'support',
      titleKey: 'service_support_title',
      descriptionKey: 'service_support_desc',
      image: HomeAssets.serviceSupport247,
    ),
    ServiceModel(
      id: 'vip_trips',
      titleKey: 'service_vip_trips_title',
      descriptionKey: 'service_vip_trips_desc',
      image: HomeAssets.serviceVipTrips,
      overlay: HomeAssets.serviceVipBanner,
    ),
    ServiceModel(
      id: 'visits',
      titleKey: 'service_visits_title',
      descriptionKey: 'service_visits_desc',
      image: HomeAssets.serviceVisitsActivities,
    ),
    ServiceModel(
      id: 'trains',
      titleKey: 'service_trains_title',
      descriptionKey: 'service_trains_desc',
      image: HomeAssets.serviceTrains,
    ),
    ServiceModel(
      id: 'flights',
      titleKey: 'service_flights_title',
      descriptionKey: 'service_flights_desc',
      image: HomeAssets.serviceFlights,
    ),
    ServiceModel(
      id: 'hotels',
      titleKey: 'service_hotels_title',
      descriptionKey: 'service_hotels_desc',
      image: HomeAssets.serviceHotels,
    ),
    ServiceModel(
      id: 'transportation',
      titleKey: 'service_transportation_title',
      descriptionKey: 'service_transportation_desc',
      image: HomeAssets.serviceTransportation,
    ),
    ServiceModel(
      id: 'sea_transport',
      titleKey: 'service_sea_transport_title',
      descriptionKey: 'service_sea_transport_desc',
      image: HomeAssets.serviceSeaTransport,
    ),
  ];
}
