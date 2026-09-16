import 'package:get/get.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/http/http_failure.dart';
import 'package:skygate/tourism/modules/travel-allowed-countries/models/travel_allowed_country_model.dart';
import 'package:skygate/tourism/modules/travel-allowed-countries/repository/get_travel_allowed_countries_repository.dart';

enum GetTravelAllowedCountriesDataStatus { initial, loading, error, success }

class TravelAllowedCountriesController extends GetxController {
  late ExpandedTileController expandedTileController1;
  late ExpandedTileController expandedTileController2;

  List<TravelAllowedCountryModel> travelAllowedCountriesList = [];

  List<String> countriesNeedVisa = [];
  List<String> countriesWithoutVisa = [];

  GetTravelAllowedCountriesDataStatus getTravelAllowedCountriesDataStatus =
      GetTravelAllowedCountriesDataStatus.initial;
  Failure getTravelAllowedCountriesDataFailure = const ServerFailure();

  late GetTravelAllowedCountriesRepository getTravelAllowedCountriesRepository;

  @override
  void onInit() async {
    super.onInit();
    expandedTileController1 = ExpandedTileController(isExpanded: false);
    expandedTileController2 = ExpandedTileController(isExpanded: false);
    getTravelAllowedCountriesRepository = GetTravelAllowedCountriesRepository();

    await getTravelAllowedCountriesData();
  }



  Future<void> getTravelAllowedCountriesData() async {
    getTravelAllowedCountriesDataStatus =
        GetTravelAllowedCountriesDataStatus.loading;
    update();

    (await getTravelAllowedCountriesRepository.getTravelAllowedCountries())
        .fold(
          (left) {
            getTravelAllowedCountriesDataStatus =
                GetTravelAllowedCountriesDataStatus.error;
            update();
          },
          (right) async {
            if (right.code == "1") {
              travelAllowedCountriesList = right.data!;
              for (var element in travelAllowedCountriesList) {
                if (element.visa_needed == "1") {
                  countriesNeedVisa.add(element.country!);
                } else {
                  countriesWithoutVisa.add(element.country!);
                }
              }
              getTravelAllowedCountriesDataStatus =
                  GetTravelAllowedCountriesDataStatus.success;
              update();
            } else {
              travelAllowedCountriesList = [];
              getTravelAllowedCountriesDataStatus =
                  GetTravelAllowedCountriesDataStatus.success;
              update();
            }
          },
        );
  }
}
