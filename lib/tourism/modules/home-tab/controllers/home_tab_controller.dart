import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/home-tab/repository/get_promotions_repository.dart';
import 'package:skygate/tourism/modules/language/language_controller.dart';

import '../models/promotion_model.dart';


enum GetPromotionsDataStatus {initial, loading, error, success}

class HomeTabController extends GetxController {

  List<PromotionModel> promotionsList = [];

  GetPromotionsDataStatus getPromotionsDataStatus = GetPromotionsDataStatus.initial;
  Failure getPromotionsDataFailure =  ServerFailure();

  final languageController = Get.find<LanguageController>();
  late GetPromotionsRepository getPromotionsRepository;

  @override
  void onInit() async {
    super.onInit();
    getPromotionsRepository = GetPromotionsRepository();
    final date = DateTime.now();
    final dayNow = DateFormat("EEEE").format(date);
    await updateFCMToken();
    await getPromotionsData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getPromotionsData() async {
      getPromotionsDataStatus = GetPromotionsDataStatus.loading;
      update();

      (await getPromotionsRepository.getPromotions())
          .fold((left) {
            getPromotionsDataFailure = left;
        getPromotionsDataStatus = GetPromotionsDataStatus.error;
        update();
      }, (right) async {
        if(right.code == "1") {
          getPromotionsDataStatus = GetPromotionsDataStatus.success;
          update();
          promotionsList = right.data!;
          SharedClass.promotionsList = promotionsList;
        } else {
          promotionsList = [];
          getPromotionsDataStatus = GetPromotionsDataStatus.success;
          update();
        }
      });
  }

  Future<void> updateFCMToken() async {
    await getPromotionsRepository.updateFCMToken();
  }

}
