import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/failures/http/http_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/airport-taxi/models/airport_model.dart';
import 'package:sky_gate/app/modules/airport-taxi/models/airport_taxi_request_model.dart';
import 'package:sky_gate/app/modules/airport-taxi/params/airport_taxi_params.dart';
import 'package:sky_gate/app/modules/airport-taxi/repository/airport_taxi_request_repository.dart';
import 'package:sky_gate/app/modules/airport-taxi/repository/get_airports_repository.dart';
import 'package:toastification/toastification.dart';

enum GetAirportTaxiRequestsDataStatus { initial, error, loading, success }

class AirportTaxiController extends GetxController {

  TextEditingController airportController = TextEditingController();
  TextEditingController homeLocationController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController planeDepartureTimeController = TextEditingController();
  TextEditingController passengersNumberController = TextEditingController();

  GetAirportTaxiRequestsDataStatus getAirportTaxiRequestsDataStatus = GetAirportTaxiRequestsDataStatus.initial;
  Failure getAirportTaxiRequestsDataFailure = const ServerFailure();

  List<AirportModel> airports = [];

  List<String> directions = [
    "من المنزل إلى المطار",
    "من المطار إلى المنزل"
  ];

  List<AirportTaxiRequestModel> airportTaxiRequestsList = [];

  List<DropdownMenuItem<String>> airportsDropdownItems = [];
  List<DropdownMenuItem<String>> tripDirectionsDropdownItems = [];

  String? selectedAirport = "";
  String? selectedTripDirection = "";
  String? selectedLocationAddress = "";

  CameraPosition kQatar = const CameraPosition(
      bearing: 0.0,
      target: LatLng(33.488810224501876, 36.29443868204927),
      tilt: 0.0,
      zoom: 20.0);

  late GoogleMapController mapController;
  late LatLng selectedLocation;

  bool airportTaxiRequestLoading = false;
  late AirportTaxiRequestRepository airportTaxiRequestRepository;
  late GetAirportsRepository getAirportsRepository;

  @override
  void onInit() async {
    super.onInit();
    airportTaxiRequestRepository = AirportTaxiRequestRepository();
    getAirportsRepository = GetAirportsRepository();
    await getAirportsData();
    await getCurrentLocation();
    airports.forEach((element) {
      airportsDropdownItems.add(DropdownMenuItem(
        value: element.name,
        child: Text(element.name!),));
    });

    directions.forEach((element) {
      tripDirectionsDropdownItems.add(DropdownMenuItem(
        value: element,
        child: Text(element),));
    });

    await getAirportTaxiRequests();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied || permission==PermissionStatus.deniedForever
          || permission==PermissionStatus.grantedLimited) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.granted) {
        return;
      }
    }

    LocationData position = await location.getLocation();
    selectedLocation = LatLng(position.latitude!,position.longitude!);
    update();
  }

  Future<void> onMapMove(CameraPosition position) async {
    selectedLocation = position.target;// Update selected location on map move
    selectedLocationAddress = '${selectedLocation.latitude}, ${selectedLocation.longitude}';
    homeLocationController.text = selectedLocation.latitude.toStringAsFixed(4) + ", " + selectedLocation.longitude.toStringAsFixed(4);
    update();
  }

  Future<void> sendTaxiRequest({BuildContext? context}) async {
    airportTaxiRequestLoading = true;
    update();

    AirportTaxiParams params = AirportTaxiParams();
    params.airport = selectedAirport;
    params.home_location = homeLocationController.text;
    params.home_address = homeAddressController.text;
    params.date = dateController.text;
    params.flight_time = planeDepartureTimeController.text;
    params.passengers_number = passengersNumberController.text;
    params.user_id = SharedClass.userId;
    params.trip_direction = selectedTripDirection;


    (await airportTaxiRequestRepository.sendTaxiRequest(params: params))
        .fold((left) {
      airportTaxiRequestLoading = false;
      update();
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("طلب تاكسي المطار"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        airportTaxiRequestLoading = false;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب تاكسي المطار"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      } else {
        airportTaxiRequestLoading = false;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب تاكسي المطار"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }

  Future<void> getAirportTaxiRequests() async {
    getAirportTaxiRequestsDataStatus = GetAirportTaxiRequestsDataStatus.loading;
    update();

    (await airportTaxiRequestRepository.getRequests())
        .fold((left) {
      getAirportTaxiRequestsDataFailure = left;
      getAirportTaxiRequestsDataStatus = GetAirportTaxiRequestsDataStatus.error;
      update();
    }, (right) async {
      if(right.code == "1") {
        right.data!.forEach((element) {
          if(element.is_new=="1") {
            airportTaxiRequestsList.add(element);
          }
        });
        getAirportTaxiRequestsDataStatus = GetAirportTaxiRequestsDataStatus.success;
        update();
      } else {
        getAirportTaxiRequestsDataFailure = CustomFailure(message: right.message!);
        airportTaxiRequestsList = [];
        getAirportTaxiRequestsDataStatus = GetAirportTaxiRequestsDataStatus.error;
        update();
      }
    });
  }


  Future<void> getAirportsData() async {
    (await getAirportsRepository.getAirports())
        .fold((left) {
    }, (right) async {
      if(right.code == "1") {
        airports = right.data!;
      } else {
        airports = [];
      }
    });
  }

}
