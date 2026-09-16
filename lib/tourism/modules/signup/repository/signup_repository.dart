import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/signup/params/signup_params.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../core/utils/failures/base_failure.dart';
import '../../../data/model/base_response/base_response.dart';

class SignupRepository {
  late HttpHelper httpHelper;

  SignupRepository() {
    httpHelper = HttpHelper();
  }

  Future<Either<Failure, BaseResponse<UserModel>>> signUp({
    required SignupParams params,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["full_name"] = params.full_name;
    requestBody["mobile"] = params.mobile;
    requestBody["password"] = params.password;
    requestBody["national_number"] = params.national_number;
    requestBody["dob"] = params.dob;
    requestBody["passport_number"] = params.passport_number;
    requestBody["passport_expiry_date"] = params.passport_expiry_date;
    requestBody["nationality"] = params.nationality;
    requestBody["lang"] = params.lang;
    requestBody["gender"] = params.gender;
    requestBody["biometrics_enabled"] = params.biometricsEnabled;
    requestBody["biometrics_key"] = params.biometricsKey;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.register,
          body: requestBody,
          decoder: (json) => UserModel.fromJSON(json),
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<UserModel>>> updateFCMToken({
    required String user_id,
    required String fcmToken,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = user_id;
    requestBody["fcm_token"] = fcmToken;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.updateFCMToken,
          body: requestBody,
          decoder: (json) => UserModel.fromJSON(json),
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}
