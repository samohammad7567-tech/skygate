import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/http/http_failure.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/home-tab/models/promotion_model.dart';

enum GetLastPromotionsDataStatus { initial, loading, error, success }

class LastPromotionsController extends GetxController {
  List<PromotionModel> promotionsList = [];

  GetLastPromotionsDataStatus getLastPromotionsDataStatus =
      GetLastPromotionsDataStatus.initial;
  Failure getPromotionsDataFailure = ServerFailure();

  @override
  void onInit() {
    super.onInit();
    promotionsList = SharedClass.promotionsList;
  }


}
