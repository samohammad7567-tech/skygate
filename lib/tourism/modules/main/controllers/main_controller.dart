import 'dart:developer';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/database/user_classes_database_helper.dart';
import 'package:skygate/tourism/modules/user/repository/get_user_repository.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import '../views/custom_buttom_navigation_bar.dart';

class MainController extends GetxController {
  late GetUserRepository getUserRepository;
  late BottomNavigationItem selectedItem;
  late LocalStorageHelper localStorageHelper = Get.find<LocalStorageHelper>();
  late UserClassesDatabaseHelper userClassesDatabaseHelper;
  Future<void>? _initialization;

  Future<void> ensureInitialized() => _initialization ??= init();

  @override
  Future<void> onInit() async {
    super.onInit();
    userClassesDatabaseHelper = Get.find<UserClassesDatabaseHelper>();
    getUserRepository = GetUserRepository();
    await ensureInitialized();
  }

  void onSelectedBottomNavigationChanged(newSelectedItem) {
    selectedItem = newSelectedItem;
    if (selectedItem == BottomNavigationItem.add) {}
    update();
  }

  @override
  void onClose() {}

  Future<void> init() async {
    await readBiometricsData();
    final result = await readUserStoredData();
    log("Result from reading User Data from Local Storage  ${result}");
    if (result == 1) {
      try {
        await localStorageHelper.readUserData();
        AppPages.INITIAL = Routes.HOME;
        SharedClass.targetPage = Routes.HOME;
      } on Failure catch (e) {
        log("Error Reading User Info : ${e.toString()}");
      }
    } else if (result == -1) {
      AppPages.INITIAL = Routes.ACCOUNT_WAITING;
      SharedClass.targetPage = Routes.ACCOUNT_WAITING;
    } else {
      AppPages.INITIAL = Routes.SPLASH;
      SharedClass.targetPage = Routes.SPLASH;
    }
  }

  Future<int> readUserStoredData() async {
    log("*****************FROM FUNCTION readUserStoredData()****************");
    try {
      final userID = await localStorageHelper.read(path: "userId");
      final userAccountStatus = await localStorageHelper.read(path: "status");
      if (userID == "") {
        return 0;
      } else if (userAccountStatus == "0") {
        final userID = await localStorageHelper.read(path: "userId");
        final token = await localStorageHelper.read(path: "token");
        final data = await getUser(userID: userID, token: token);
        return data;
      } else {
        return 1;
      }
    } on Exception catch (e) {
      return 0;
    }
  }

  Future<int> getUser({String? token, String? userID}) async {
    int result = -3000;
    (await getUserRepository.getUserByID(token: token, userID: userID)).fold(
      (left) {
        final error = FailureParser.mapFailureToString(
          failure: left,
          context: Get.overlayContext!,
        );
        log("Get User By ID API ERROR : ${error}");
        result = -1;
      },
      (right) {
        if (right.code == "1") {
          final userModel = right.data!;
          if (userModel.status == "1") {
            result = -200;
          } else {
            result = -1;
          }
        } else {
          result = -1;
        }
      },
    );
    return result;
  }

  Future<void> readBiometricsData() async {
    try {
      SharedClass.biometricsEnabled = await localStorageHelper.read(
        path: "biometricsEnabled",
      );
      SharedClass.biometricsKey = await localStorageHelper.read(
        path: "biometricsKey",
      );
    } on Exception catch (e) {
      log("Error while reading user biometrics data: ${e.toString()}");
    }
  }
}
