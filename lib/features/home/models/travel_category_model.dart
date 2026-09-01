import 'package:skygate/core/constants/home_assets.dart';

/// One pill in the horizontal row under the hero (عمرة، طيران، فنادق ...).
///
/// The row is fixed design content — the label is a localization key and the
/// icon is a bundled asset — so it ships as a local [catalogue] rather than
/// coming down from the API.
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

  /// Ordered right-to-left exactly as in the design: عمرة sits on the start
  /// (right) edge and is the pill selected on first paint.
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
  ];
}
