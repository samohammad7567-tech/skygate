import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/change-operation/models/change_request_model.dart';

class GetChangeRequestRepository {
  late HttpHelper httpHelper;

  GetChangeRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<ChangeRequestModel>>> getChangeRequest({String? booking_request_number}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["booking_request_number"] = booking_request_number;
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.getOneChangeRequest,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return ChangeRequestModel.fromJson(json);
            } else {
              return ChangeRequestModel();
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}