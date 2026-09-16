import 'package:get/get.dart';
import '../../../core/utils/helpers/http_helper.dart';

class ApiNotificationProvider {
  late final HttpHelper httpHelper;
  late final String token;

  ApiNotificationProvider(this.token) {
    httpHelper = Get.find<HttpHelper>();
  }
}
