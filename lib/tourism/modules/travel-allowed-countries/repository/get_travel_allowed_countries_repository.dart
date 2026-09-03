import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/modules/travel-allowed-countries/models/travel_allowed_country_model.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../data/shared/shared_class.dart';

class GetTravelAllowedCountriesRepository {
  late HttpHelper httpHelper;

  GetTravelAllowedCountriesRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<List<TravelAllowedCountryModel>>>> getTravelAllowedCountries() async {
    try {
      return right(await httpHelper.get(
          NetworkRoutesControl.getTravelAllowedCountries,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          decoder: (json) {
            if(json != null) {
              return json.map<TravelAllowedCountryModel>((json) => TravelAllowedCountryModel.fromJson(json)).toList();
            } else {
              return [];
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}