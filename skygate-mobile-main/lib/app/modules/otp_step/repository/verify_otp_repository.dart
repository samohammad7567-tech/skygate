import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';

class VerifyOTPRepository {
  late HttpHelper httpHelper;

  VerifyOTPRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> verifyOTP({
    required String mobile, required String otp}) async {
    Map<String,dynamic> requestBody = {};
    requestBody["mobile"] = mobile;
    requestBody["otp_code"] = otp;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.verifyOTP,
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return true;
            } else {
              return false;
            }
          }));
    } on Failure catch(e) {
      return left(e);
    }
  }

}