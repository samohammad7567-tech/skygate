import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/models/city_model.dart';

class GetCitiesRepository {
  late HttpHelper httpHelper;

  GetCitiesRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<List<CityModel>>>> getCities() async {
    try {
      return right(await httpHelper.get(
          NetworkRoutesControl.getCities,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          decoder: (json) {
            if(json != null) {
              return json.map<CityModel>((json) => CityModel.fromJson(json)).toList();
            } else {
              return [];
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}