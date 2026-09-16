import 'package:get/get.dart';
import '../../../core/utils/helpers/http_helper.dart';

class ApiAuthProvider {
  late final HttpHelper httpHelper;

  ApiAuthProvider() {
    httpHelper = Get.find<HttpHelper>();
  }
}
