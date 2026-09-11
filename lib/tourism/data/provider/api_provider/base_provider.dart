import '../../../core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';

// import '../../model/base_response.dart';
class ApiBaseProvider {
  late final HttpHelper httpHelper;

  ApiBaseProvider() {
    httpHelper = Get.find<HttpHelper>();
  }
}
