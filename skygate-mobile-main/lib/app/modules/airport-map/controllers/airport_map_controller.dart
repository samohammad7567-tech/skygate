import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/failures/http/http_failure.dart';
import 'package:sky_gate/app/modules/airport-taxi/models/airport_model.dart';
import 'package:sky_gate/app/modules/airport-taxi/repository/get_airports_repository.dart';


enum PrepareMapPageStatus {initial, loading, success}
enum GetAirportsStatus {initial, loading, error, success}

class AirportMapController extends GetxController {

  late LatLng userLocation;
  late LatLng destinationLocation;
  RxString totalDistance = "".obs;
  RxString totalTime = "".obs;

  List<AirportModel> airports = [];
  List<DropdownMenuItem<String>> airportsDropdownItems = [];

  PrepareMapPageStatus prepareMapPageStatus = PrepareMapPageStatus.initial;
  GetAirportsStatus getAirportsStatus = GetAirportsStatus.initial;
  Failure getAirportsFailure = const ServerFailure();


  late GetAirportsRepository getAirportsRepository;

  @override
  void onInit() async {
    super.onInit();
    getAirportsRepository = GetAirportsRepository();
    await getAirportsData();
    airports.forEach((element) {
      airportsDropdownItems.add(DropdownMenuItem(
        value: element.name,
        child: Text(element.name!),));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onAirportSelected(String? name) {
    airports.forEach((element) {
      if(element.name == name) {
        destinationLocation = LatLng(element.location!.coordinates![1], element.location!.coordinates![0]);
      }
    });
  }

  Future<void> getCurrentLocation() async {
    getAirportsStatus = GetAirportsStatus.initial;
    prepareMapPageStatus = PrepareMapPageStatus.loading;
    update();
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        prepareMapPageStatus = PrepareMapPageStatus.success;
        update();
        return;
      }
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied || permission==PermissionStatus.deniedForever
        || permission==PermissionStatus.grantedLimited) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.granted) {
        prepareMapPageStatus = PrepareMapPageStatus.success;
        update();
        return;
      }
    }

    LocationData position = await location.getLocation();
    userLocation = LatLng(position.latitude!,position.longitude!);
    prepareMapPageStatus = PrepareMapPageStatus.success;
    update();
  }

  Future<void> getAirportsData() async {
    getAirportsStatus = GetAirportsStatus.loading;
    update();
    (await getAirportsRepository.getAirports())
        .fold((left) {
          getAirportsFailure = left;
          getAirportsStatus = GetAirportsStatus.error;
          update();
    }, (right) async {
      if(right.code == "1") {
        airports = right.data!;
        getAirportsStatus = GetAirportsStatus.success;
        update();
      } else {
        airports = [];
        getAirportsStatus = GetAirportsStatus.success;
        update();
      }
    });
  }
}
