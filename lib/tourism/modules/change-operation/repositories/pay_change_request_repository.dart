import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';

class PayChangeRequestRepository {
  late HttpHelper httpHelper;

  PayChangeRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> payChangeRequest({
    String? booking_request_number,
    String? payment_method,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    requestBody["booking_request_number"] = booking_request_number;
    requestBody["payment_method"] = payment_method;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.payChangeRequest,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return json;
            } else {
              return false;
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}
