import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/home-tab/models/promotion_model.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';


class GetPromotionsRepository {
  late HttpHelper httpHelper;

  GetPromotionsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<UserModel>>> updateFCMToken() async {
    Map<String,dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    requestBody["fcm_token"] = SharedClass.fcmToken;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.updateFCMToken,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
                if(json != null) {
                  return UserModel.fromJSON(json);
                } else {
                  return UserModel();
                }
          }));
    } on Failure catch(e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<List<PromotionModel>>>> getPromotions() async {
    try {
      return right(await httpHelper.get(
          NetworkRoutesControl.getAllPromotions,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          decoder: (json) {
                if(json != null) {
                  return json.map<PromotionModel>((json) => PromotionModel.fromJson(json)).toList();
                } else {
                  return [];
                }
          }));
    } on Failure catch(e) {
      return left(e);
    }
  }
}