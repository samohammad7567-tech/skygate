import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/features/carriers/models/carrier_model.dart';

part 'carriers_state.dart';

class CarriersCubit extends Cubit<CarriersState> {
  CarriersCubit(this.category) : super(CarriersInitial());

  CarriersCubit get(BuildContext context) => BlocProvider.of(context);
  final CarrierCategory category;
  List<CarrierModel> _all = [];
  List<CarrierModel> carriers = [];
  String query = '';

  Future<void> getCarriers() async {
    emit(CarriersLoading());
    _all = CarrierModel.catalogueOf(category);
    _applyFilters();
    emit(CarriersLoaded());
  }

  void search(String value) {
    query = value.trim();
    _applyFilters();
    emit(CarriersLoaded());
  }

  void _applyFilters() {
    carriers = [
      for (final carrier in _all)
        if (carrier.matches(query)) carrier,
    ];
  }
}
