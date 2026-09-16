import 'package:get/get.dart';
import '../utils/failures/http/http_failure.dart';
import '../utils/helpers/http_helper.dart';

class ErrorHandler {
  void listenForErrors() {
    final httpHelper = Get.find<HttpHelper>();
    if (!httpHelper.hasListener()) {
      httpHelper.listenForErrors().listen((httpFailure) {
        if (httpFailure is UnauthorizedFailure) {
          Get.showSnackbar(
            const GetSnackBar(message: 'You are not Authenticated'),
          );
        }
      });
    }
  }
}
