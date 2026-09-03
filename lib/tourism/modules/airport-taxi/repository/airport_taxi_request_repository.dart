import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/airport-taxi/models/airport_taxi_request_model.dart';
import 'package:skygate/tourism/modules/airport-taxi/params/airport_taxi_params.dart';
import '../../../core/utils/failures/base_failure.dart';
import '../../../data/model/base_response/base_response.dart';
import 'package:get/get.dart';

class AirportTaxiRequestRepository {
  late HttpHelper httpHelper;

  AirportTaxiRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> sendTaxiRequest({AirportTaxiParams? params}) async {
    Map<String,dynamic> requestBody = {};
    requestBody["airport"] = params!.airport;
    requestBody["home_location"] = params.home_location;
    requestBody["home_address"] = params.home_address;
    requestBody["date"] = params.date;
    requestBody["flight_time"] = params.flight_time;
    requestBody["passengers_number"] = params.passengers_number;
    requestBody["user_id"] = params.user_id;
    requestBody["trip_direction"] = params.trip_direction;
        try {
          return right(await httpHelper.post(
              NetworkRoutesControl.createAirportTaxiRequest,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
              decoder: (json) {
                if(json != null) {
                  return json;
                } else {
                  return false;
                }
              }));
        } on Failure catch(e) {
          return left(e);
        }
  }

  Future<Either<Failure, BaseResponse<List<AirportTaxiRequestModel>>>> getRequests() async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.getAirportTaxiRequests,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return json.map<AirportTaxiRequestModel>((json) => AirportTaxiRequestModel.fromJson(json)).toList();
            } else {
              return [];
            }
          }));
    } on Failure catch (e) {
      return left(e);
    }
  }

}
