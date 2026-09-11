import 'package:skygate/core/constants/home_assets.dart';

class TravelCategoryModel {
  final String id;
  final String titleKey;
  final String icon;

  const TravelCategoryModel({
    required this.id,
    required this.titleKey,
    required this.icon,
  });

  TravelCategoryModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      titleKey = json['title'] ?? '',
      icon = json['icon'] ?? HomeAssets.umrah;
  static const List<TravelCategoryModel> catalogue = [
    TravelCategoryModel(
      id: 'umrah',
      titleKey: 'category_umrah',
      icon: HomeAssets.umrah,
    ),
    TravelCategoryModel(
      id: 'flights',
      titleKey: 'category_flights',
      icon: HomeAssets.flight,
    ),
    TravelCategoryModel(
      id: 'hotels',
      titleKey: 'category_hotels',
      icon: HomeAssets.hotel,
    ),
    TravelCategoryModel(
      id: 'trains',
      titleKey: 'category_trains',
      icon: HomeAssets.train,
    ),
    TravelCategoryModel(
      id: 'sea_transport',
      titleKey: 'category_sea_transport',
      icon: HomeAssets.seaTransport,
    ),
    TravelCategoryModel(
      id: 'transport',
      titleKey: 'category_transport',
      icon: HomeAssets.car,
    ),
  ];
}
