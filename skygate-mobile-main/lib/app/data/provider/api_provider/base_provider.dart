import '../../../core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
// import '../../model/base_response.dart';

/// this provider starts with the application and still until close the application ,it help to
/// loads general data like gender,banks,currencies,countries from the api
class ApiBaseProvider {
    late final HttpHelper httpHelper;

  ApiBaseProvider() {
    httpHelper = Get.find<HttpHelper>();
  }

}
