import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';

class AcceptTripConditionsRepository {
  late HttpHelper httpHelper;

  AcceptTripConditionsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> acceptTripConditions({String? ticketID}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    requestBody["ticket_id"] = ticketID;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.acceptTripConditions,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return json;
            } else {
              return false;
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}