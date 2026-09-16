import 'package:get/get.dart';

import '../../../core/utils/helpers/local_storage_helper.dart';

class LocalLanguageProvider {
  static const String appLanguagePath = 'app_language';

  LocalStorageHelper? helper;

  LocalLanguageProvider() {
    helper = Get.find<LocalStorageHelper>();
  }
}
