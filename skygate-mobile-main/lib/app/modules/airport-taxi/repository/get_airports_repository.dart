import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/airport-taxi/models/airport_model.dart';

class GetAirportsRepository {
  late HttpHelper httpHelper;

  GetAirportsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<List<AirportModel>>>> getAirports() async {
    try {
      return right(await httpHelper.get(
          NetworkRoutesControl.getAllAirports,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          decoder: (json) {
            if(json != null) {
              return json.map<AirportModel>((json) => AirportModel.fromJson(json)).toList();
            } else {
              return [];
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}