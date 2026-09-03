import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';

class FingerprintLoginRepository {
  late HttpHelper httpHelper;

  FingerprintLoginRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<UserModel>>> fingerprintSignIn() async {
    Map<String,dynamic> requestBody = {};
    requestBody["biometrics_key"] = SharedClass.biometricsKey;
    try {
      return right(await httpHelper.post(NetworkRoutesControl.biometricsLogin,
          body: requestBody, decoder: (json) => UserModel.fromJSON(json)));
    } on Failure catch(e) {
      return left(e);
    }
  }
}