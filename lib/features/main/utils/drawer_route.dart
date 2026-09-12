import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/coming_soon_view.dart';
import 'package:skygate/features/booking_changes/views/booking_change_requests_screen.dart';
import 'package:skygate/features/main/models/drawer_item_model.dart';
import 'package:skygate/features/sos/controller/cubit/lost_items_cubit.dart';
import 'package:skygate/features/sos/controller/cubit/support_chat_cubit.dart';
import 'package:skygate/features/sos/views/lost_items_screen.dart';
import 'package:skygate/features/sos/views/support_chat_screen.dart';
import 'package:skygate/features/vip_trip/views/vip_requests_screen.dart';

/// What a drawer row that is not one of the shell's tabs opens.
///
/// Each screen brings the cubit it reads from, because the drawer is popped
/// before the route is pushed — nothing of the panel's own tree survives the
/// trip.
Widget drawerItemScreen(DrawerItemModel item) => switch (item.labelKey) {
  'drawer_lost_items' => BlocProvider(
    create: (_) => LostItemsCubit()..getItems(),
    child: const LostItemsScreen(),
  ),
  'drawer_amend_bookings' => const BookingChangeRequestsScreen(),
  'drawer_private_trips' => const VipRequestsScreen(),
  'drawer_support' => BlocProvider(
    create: (_) => SupportChatCubit()..openChat(),
    child: const SupportChatScreen(),
  ),
  _ => ComingSoonView(titleKey: item.labelKey),
};
