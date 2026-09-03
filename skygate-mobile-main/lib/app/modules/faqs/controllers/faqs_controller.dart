import 'package:get/get.dart';
import '../../../data/model/faqs_model/faqs_model.dart';

class FaqsController extends GetxController {

  RxBool isLoading = true.obs;
  List<FAQsModel> allFAQsList = [];

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


}
