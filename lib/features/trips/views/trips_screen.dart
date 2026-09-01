import 'package:flutter/material.dart';
import 'package:skygate/core/components/coming_soon_view.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComingSoonView(titleKey: 'nav_trips');
}
