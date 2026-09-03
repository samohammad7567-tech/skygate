import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/my-bookings-requests/models/booking_request_model.dart';

class GetBookingRequestRepository {
  late HttpHelper httpHelper;

  GetBookingRequestRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<BookingRequestModel>>> getBookingsRequest({String? id}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["booking_id"] = id;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.getBookingRequestByID,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return BookingRequestModel.fromJson(json);
            } else {
              return BookingRequestModel();
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}