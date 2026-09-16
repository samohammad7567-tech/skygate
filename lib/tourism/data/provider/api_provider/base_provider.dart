import '../../../core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';

class ApiBaseProvider {
  late final HttpHelper httpHelper;

  ApiBaseProvider() {
    httpHelper = Get.find<HttpHelper>();
  }
}
