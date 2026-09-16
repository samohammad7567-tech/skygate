import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';

class LanguageRepository {
  late HttpHelper httpHelper;

  LanguageRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<String>>> updateUserLang({
    required String user_id,
    required String lang,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = user_id;
    requestBody["lang"] = lang;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.updateUserLang,
          body: requestBody,
          decoder: (json) {
            if (json.isNotEmpty) {
              return json;
            } else {
              return "";
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}
