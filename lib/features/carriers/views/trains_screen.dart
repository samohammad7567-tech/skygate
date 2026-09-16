import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/carriers/controller/cubit/carriers_cubit.dart';
import 'package:skygate/features/carriers/models/carrier_model.dart';
import 'package:skygate/features/carriers/widgets/carriers_body.dart';

class TrainsScreen extends StatelessWidget {
  const TrainsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarriersCubit(CarrierCategory.trains)..getCarriers(),
      child: const CarriersBody(),
    );
  }
}
