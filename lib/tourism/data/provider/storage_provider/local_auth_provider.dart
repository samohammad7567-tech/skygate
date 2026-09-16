import 'package:get/get.dart';
import '../../../core/utils/helpers/local_storage_helper.dart';

class LocalAuthProvider {
  static const String userInfoPath = 'user';

  static const String appInformationPath = 'app_information';

  late final LocalStorageHelper helper;

  LocalAuthProvider() {
    helper = Get.find<LocalStorageHelper>();
  }
}
