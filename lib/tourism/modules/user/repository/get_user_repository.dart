import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';

class GetUserRepository {
  late HttpHelper httpHelper;

  GetUserRepository() {
    httpHelper = Get.find<HttpHelper>();
  }


  Future<Either<Failure, BaseResponse<UserModel>>> getUserByID({String? token, String? userID}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = userID;
    try {
      return right(await httpHelper.post(
        NetworkRoutesControl.getUser,
        body: requestBody,
        headers: HttpHelper.basicHeaderWithToken(token!),
        decoder: (json) {
          if(json != null) {
            return UserModel.fromJSON(json);
          } else {
            return UserModel();
          }
        },
      ));
    } on Failure catch (e) {
      return left(e);
    }
  }
}