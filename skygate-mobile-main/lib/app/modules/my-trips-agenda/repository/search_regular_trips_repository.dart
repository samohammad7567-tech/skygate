import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/models/regular_trip_model.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/params/search_trips_params.dart';

class SearchRegularTripsRepository {
  late HttpHelper httpHelper;

  SearchRegularTripsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<RegularTripModel>>> searchTrips({SearchTripsParams? params}) async {
    Map<String, dynamic> requestBody = {};

    requestBody["departure_city"] = params!.departure_city;
    requestBody["arrival_city"] = params.arrival_city;
    requestBody["departure_date"] = params.departure_date;
    requestBody["return_date"] = params.return_date;
    requestBody["is_round_trip"] = params.is_round_trip;

    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.searchRegularTrips,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return RegularTripModel.fromJson(json);
            } else {
              return RegularTripModel();
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}