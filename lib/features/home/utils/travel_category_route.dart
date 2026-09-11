import 'package:flutter/material.dart';
import 'package:skygate/features/carriers/views/flights_screen.dart';
import 'package:skygate/features/carriers/views/maritime_transport_screen.dart';
import 'package:skygate/features/carriers/views/trains_screen.dart';
import 'package:skygate/features/carriers/views/transport_screen.dart';
import 'package:skygate/features/hotels/views/hotels_browse_screen.dart';

Widget? travelCategoryScreen(String categoryId) => switch (categoryId) {
  'flights' => const FlightsScreen(),
  'hotels' => const HotelsBrowseScreen(),
  'trains' => const TrainsScreen(),
  'sea_transport' => const MaritimeTransportScreen(),
  'transport' => const TransportScreen(),
  _ => null,
};
