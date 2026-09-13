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

  /// The panel, top to bottom. The first group is the bottom bar's own five
  /// destinations — الإعدادات sits with الدعم in the design rather than with
  /// its siblings, but it still switches the tab instead of pushing a route.
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
          labelKey: 'nav_map',
          icon: DrawerAssets.map,
          tabIndex: 2,
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
          labelKey: 'drawer_amend_bookings',
          icon: DrawerAssets.updateBooking,
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
        DrawerItemModel(
          labelKey: 'nav_settings',
          icon: DrawerAssets.settings,
          tabIndex: 4,
        ),
      ],
    ),
  ];
}
