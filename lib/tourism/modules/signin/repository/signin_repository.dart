import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import '../../../core/utils/failures/base_failure.dart';
import '../../../data/model/base_response/base_response.dart';
import 'package:get/get.dart';

class SignInRepository {
  late HttpHelper httpHelper;

  SignInRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<UserModel>>> signIn({
    required String mobile, required String password}) async {
    Map<String,dynamic> requestBody = {};
    requestBody["mobile"] = mobile;
    requestBody["password"] = password;
        try {
          return right(await httpHelper.post(NetworkRoutesControl.login,
          body: requestBody, decoder: (json) => UserModel.fromJSON(json)));
        } on Failure catch(e) {
          return left(e);
        }
  }

  Future<Either<Failure, BaseResponse<UserModel>>> updateFCMToken({
    required String user_id, required String fcmToken}) async {
    Map<String,dynamic> requestBody = {};
    requestBody["user_id"] = user_id;
    requestBody["fcm_token"] = fcmToken;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.updateFCMToken,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) => UserModel.fromJSON(json)));
    } on Failure catch(e) {
      return left(e);
    }
  }
}
