import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/hotels/controller/cubit/hotels_browse_cubit.dart';
import 'package:skygate/features/hotels/widgets/hotels_browse_body.dart';

class HotelsBrowseScreen extends StatelessWidget {
  const HotelsBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotelsBrowseCubit()..getHotels(),
      child: const HotelsBrowseBody(),
    );
  }
}
