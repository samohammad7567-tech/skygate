import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/params/submit_booking_request_params.dart';

class SubmitBookingRequestRepository {
  late HttpHelper httpHelper;

  SubmitBookingRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> submit({SubmitBookingRequestParams? params}) async {
    Map<String, dynamic> requestBody = {};

    requestBody["related_user"] = params!.related_user;
    requestBody["is_regular_trip"] = params.is_regular_trip;
    requestBody["regular_trip_id"] = params.regular_trip_id;
    requestBody["departure_place"] = params.departure_place;
    requestBody["arrival_place"] = params.arrival_place;
    requestBody["is_one_way"] = params.is_one_way;
    requestBody["departure_date"] = params.departure_date;
    requestBody["return_date"] = params.return_date;
    requestBody["trip_level"] = params.trip_level;
    requestBody["adults_number"] = params.adults_number;
    requestBody["children_number"] = params.children_number;
    requestBody["status"] = params.status;
    requestBody["total_cost"] = params.total_cost;
    requestBody["currency"] = params.currency;
    requestBody["babies_number"] = params.babies_number;
    requestBody["nationality"] = params.nationality;
    requestBody["payment_method"] = params.payment_method;

    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.createBookingRequest,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return json;
            } else {
              return false;
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}