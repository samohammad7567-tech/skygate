import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/language/language_controller.dart';

class AccountRepository {
  late LanguageController languageController;
  late HttpHelper httpHelper;

  AccountRepository() {
    languageController = Get.find<LanguageController>();
    httpHelper = Get.find<HttpHelper>();
  }


  Future<Either<Failure, BaseResponse<bool>>> deleteUserProfile() async {
    Map<String,dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(
        await httpHelper.post(
        NetworkRoutesControl.deleteAccount,
            headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
        decoder: (json) {
          if (json != null) {
            return json;
          } else {
            return false;
          }
        },
          body: requestBody
      )
      );
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<bool>>> logoutUser() async {
    Map<String,dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(
          await httpHelper.post(
              NetworkRoutesControl.logout,
              headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
              decoder: (json) {
                if (json != null) {
                  return json;
                } else {
                  return false;
                }
              },
              body: requestBody
          )
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}