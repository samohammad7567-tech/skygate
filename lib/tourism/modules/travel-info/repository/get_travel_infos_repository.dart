import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/modules/travel-info/models/travel_info_model.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../data/shared/shared_class.dart';

class GetTravelInfosRepository {
  late HttpHelper httpHelper;

  GetTravelInfosRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<List<TravelInfoModel>>>>
  getTravelInfos() async {
    try {
      return right(
        await httpHelper.get(
          NetworkRoutesControl.getAboutTravelInfos,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          decoder: (json) {
            if (json != null) {
              return json
                  .map<TravelInfoModel>(
                    (json) => TravelInfoModel.fromJson(json),
                  )
                  .toList();
            } else {
              return [];
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}
