import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/my-bookings-requests/models/payment_method_model.dart';

class GetPaymentMethodsRepository {
  late HttpHelper httpHelper;

  GetPaymentMethodsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<List<PaymentMethodModel>>>> getPaymentMethods() async {
    try {
      return right(await httpHelper.get(
          NetworkRoutesControl.getPaymentMethods,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          decoder: (json) {
            if(json != null) {
              return json.map<PaymentMethodModel>((json) => PaymentMethodModel.fromJson(json)).toList();
            } else {
              return [];
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}