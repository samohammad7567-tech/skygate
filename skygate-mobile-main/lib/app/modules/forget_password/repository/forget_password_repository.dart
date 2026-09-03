import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import '../../../core/utils/failures/base_failure.dart';
import '../../../data/model/base_response/base_response.dart';
import 'package:get/get.dart';

class ForgetPasswordRepository {
  late HttpHelper httpHelper;

  ForgetPasswordRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse>> forgetPassword({
    required String mobile, required String password}) async {
    Map<String,dynamic> requestBody = {};
    requestBody["mobile"] = mobile;
    requestBody["password"] = password;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.forgetPassword,
          body: requestBody,
          decoder: (json) => []));
    } on Failure catch(e) {
      return left(e);
    }
  }

}
