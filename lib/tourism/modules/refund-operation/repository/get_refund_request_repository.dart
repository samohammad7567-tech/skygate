import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/refund-operation/models/refund_request_model.dart';

class GetRefundRequestRepository {
  late HttpHelper httpHelper;

  GetRefundRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<RefundRequestModel>>> getRefundRequest({
    String? booking_request_number,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["booking_request_number"] = booking_request_number;
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.getOneRefundRequest,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return RefundRequestModel.fromJson(json);
            } else {
              return RefundRequestModel();
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}
