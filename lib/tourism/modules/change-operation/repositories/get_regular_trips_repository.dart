import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/my-trips-agenda/models/trip_model.dart';

class GetRegularTripsRepository {
  late HttpHelper httpHelper;

  GetRegularTripsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<TripModel>>> getRegularTripByID({
    String? trip_id,
  }) async {
    Map<String, dynamic> requestBody = {};
    requestBody["trip_id"] = trip_id;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.getRegularTripByID,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return TripModel.fromJson(json);
            } else {
              return TripModel();
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<List<TripModel>>>>
  getRegularTripsSameCompany({String? company_id}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["company_id"] = company_id;
    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.getRegularTripsSameCompany,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return json
                  .map<TripModel>((json) => TripModel.fromJson(json))
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
