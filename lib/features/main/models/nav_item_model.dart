import 'package:skygate/core/constants/home_assets.dart';

/// One destination in the floating bottom navigation bar.
class NavItemModel {
  final String id;
  final String labelKey;
  final String icon;

  const NavItemModel({
    required this.id,
    required this.labelKey,
    required this.icon,
  });

  /// Ordered as in the design: الرئيسية is the first (start-side) item.
  static const List<NavItemModel> items = [
    NavItemModel(id: 'home', labelKey: 'nav_home', icon: HomeAssets.navHome),
    NavItemModel(id: 'trips', labelKey: 'nav_trips', icon: HomeAssets.navTrips),
    NavItemModel(id: 'map', labelKey: 'nav_map', icon: HomeAssets.navMap),
    NavItemModel(
      id: 'account',
      labelKey: 'nav_account',
      icon: HomeAssets.navAccount,
    ),
    NavItemModel(
      id: 'settings',
      labelKey: 'nav_settings',
      icon: HomeAssets.navSettings,
    ),
  ];
}
