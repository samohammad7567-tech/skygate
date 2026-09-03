import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';

class SubmitChangeRequestRepository {
  late HttpHelper httpHelper;

  SubmitChangeRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> submitChangeRequest({required String? booking_request_number,
    required String? change_type,required String? first_way_trip_id,required String? return_trip_id}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    requestBody["booking_request_number"] = booking_request_number;
    requestBody["change_type"] = change_type;
    requestBody["first_way_trip_id"] = first_way_trip_id;
    requestBody["return_trip_id"] = return_trip_id;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.submitChangeRequest,
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