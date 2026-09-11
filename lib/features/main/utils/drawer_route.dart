import 'package:flutter/material.dart';
import 'package:skygate/core/components/coming_soon_view.dart';
import 'package:skygate/features/main/models/drawer_item_model.dart';
import 'package:skygate/features/vip_trip/views/vip_requests_screen.dart';

Widget drawerItemScreen(DrawerItemModel item) => switch (item.labelKey) {
  'drawer_private_trips' => const VipRequestsScreen(),
  _ => ComingSoonView(titleKey: item.labelKey),
};
