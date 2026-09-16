import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';

class SendOTPRepository {
  late HttpHelper httpHelper;

  SendOTPRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> sendOTP({
    required String mobile,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["mobile"] = mobile;
    requestBody["fcm_token"] = SharedClass.fcmToken;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.sendOTP,
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return true;
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
