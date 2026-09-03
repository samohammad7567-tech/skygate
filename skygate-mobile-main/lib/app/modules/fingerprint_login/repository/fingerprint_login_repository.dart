import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/user/user_model.dart';

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