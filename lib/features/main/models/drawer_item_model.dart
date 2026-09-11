import 'package:skygate/core/constants/drawer_assets.dart';

class DrawerItemModel {
  final String labelKey;
  final String icon;
  final int? tabIndex;

  const DrawerItemModel({
    required this.labelKey,
    required this.icon,
    this.tabIndex,
  });

  bool get isTab => tabIndex != null;
}

class DrawerSectionModel {
  final String? titleKey;
  final List<DrawerItemModel> items;

  const DrawerSectionModel({required this.items, this.titleKey});
  static const List<DrawerSectionModel> catalogue = [
    DrawerSectionModel(
      items: [
        DrawerItemModel(
          labelKey: 'nav_home',
          icon: DrawerAssets.home,
          tabIndex: 0,
        ),
        DrawerItemModel(
          labelKey: 'nav_trips',
          icon: DrawerAssets.trips,
          tabIndex: 1,
        ),
        DrawerItemModel(
          labelKey: 'nav_account',
          icon: DrawerAssets.account,
          tabIndex: 3,
        ),
      ],
    ),
    DrawerSectionModel(
      titleKey: 'drawer_pilgrim_services',
      items: [
        DrawerItemModel(
          labelKey: 'drawer_lost_items',
          icon: DrawerAssets.lostItems,
        ),
        DrawerItemModel(
          labelKey: 'drawer_private_trips',
          icon: DrawerAssets.privateTrips,
        ),
        DrawerItemModel(labelKey: 'drawer_alerts', icon: DrawerAssets.alerts),
      ],
    ),
    DrawerSectionModel(
      titleKey: 'drawer_support_section',
      items: [
        DrawerItemModel(labelKey: 'drawer_support', icon: DrawerAssets.support),
        DrawerItemModel(labelKey: 'drawer_faq', icon: DrawerAssets.faq),
      ],
    ),
  ];
}
