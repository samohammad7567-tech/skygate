import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';

class FingerprintSetupRepository {
  late HttpHelper httpHelper;

  FingerprintSetupRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> fingerprintSetup() async {
    Map<String, dynamic> requestBody = {};
    requestBody["biometrics_key"] = SharedClass.biometricsKey;
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.biometricsEnable,
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
