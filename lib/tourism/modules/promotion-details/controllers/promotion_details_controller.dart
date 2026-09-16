import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/home-tab/models/promotion_model.dart';
import 'package:skygate/tourism/modules/messages/repositoy/messages_repository.dart';
import 'package:toastification/toastification.dart';

class PromotionDetailsController extends GetxController {
  late PromotionModel promotion;
  late int? promotionID;
  bool sendMsgLoading = false;
  late MessagesRepository messagesRepository;
  @override
  void onInit() {
    super.onInit();
    messagesRepository = MessagesRepository();
    promotionID = Get.arguments["id"];
    promotion = SharedClass.promotionsList.firstWhere(
      (item) => item.id == promotionID,
    );
  }



  Future<void> sendMessage({BuildContext? context}) async {
    sendMsgLoading = true;
    update();

    String message =
        "أرجو التقدم بطلب حجز تذكرة للرحلة المعلنة من ${promotion.from} إلى ${promotion.to}";

    (await messagesRepository.sendMessage(
      msg: message,
      targetTeam: AppConfig.customerCareTeam.toString(),
    )).fold(
      (left) {
        sendMsgLoading = false;
        update();
        String? error = FailureParser.mapFailureToString(
          failure: left,
          context: context!,
        );
        toastification.show(
          context: context,
          title: const Text("طلب حجز تذكرة"),
          description: Text(error),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      },
      (right) async {
        if (right.code == "1") {
          sendMsgLoading = false;
          update();
          toastification.show(
            context: context,
            title: const Text("طلب حجز تذكرة"),
            description: Text(right.message!),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
        } else {
          sendMsgLoading = false;
          update();
          toastification.show(
            context: context,
            title: const Text("طلب حجز تذكرة"),
            description: Text(right.message!),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
        }
      },
    );
  }
}
