import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';

class SubmitRefundRequestRepository {
  late HttpHelper httpHelper;

  SubmitRefundRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> submitRefundRequest({String? booking_request_number, String? refund_type}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    requestBody["booking_request_number"] = booking_request_number;
    requestBody["refund_type"] = refund_type;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.submitRefundRequest,
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