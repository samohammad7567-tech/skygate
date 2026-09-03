import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/database/user_classes_database_helper.dart';
import 'package:skygate/tourism/modules/language/language_controller.dart';
import 'package:skygate/tourism/modules/signup/params/signup_params.dart';
import 'package:skygate/tourism/modules/signup/repository/signup_repository.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import 'package:toastification/toastification.dart';
import 'package:permission_handler/permission_handler.dart';

enum SignUpStatus { initial, error, loading, success }

enum GetDataStatus { initial, error, loading, success }

enum CameraPermissionStatus { loading, granted, denied }

class SignupController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  TextEditingController passportExpiryDateController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String? mobileNum = "";
  String? selectedGender = "";
  String? selectedNationality = "";

  List<DropdownMenuItem<String>> genderItemsList = [
    DropdownMenuItem(
      child: Text("ذكر",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
      value: "ذكر",
    ),
    DropdownMenuItem(
      child: Text("أنثى",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
      value: "أنثى",
    ),
  ];

  List<DropdownMenuItem<String>> nationalityItemsList = [];

  RxBool? isPassword = true.obs;
  RxBool? isPasswordConfirm = true.obs;
  RxBool? isLoading = false.obs;

  late SignupRepository signupRepository;
  late LocalStorageHelper localStorageHelper;

  SignUpStatus signUpStatus = SignUpStatus.initial;
  GetDataStatus getDataStatus = GetDataStatus.loading;
  CameraPermissionStatus cameraPermissionStatus =
      CameraPermissionStatus.loading;
  Failure signUpFailure = ServerFailure();
  Failure getDataFailure = ServerFailure();

  late UserClassesDatabaseHelper userClassDatabaseHelper;
  late LanguageController languageController;

  @override
  void onInit() {
    super.onInit();
    AppConfig.arabicNationalities.forEach((element) {
      nationalityItemsList.add(
        DropdownMenuItem(
          child: Text("${element}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
          value: "${element}",
        ),
      );
    });
    signupRepository = SignupRepository();
    userClassDatabaseHelper = Get.find<UserClassesDatabaseHelper>();
    localStorageHelper = Get.find<LocalStorageHelper>();
    languageController = Get.find<LanguageController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> signUp({BuildContext? context}) async {
    signUpStatus = SignUpStatus.loading;
    update();

    SignupParams params = SignupParams();
    params.full_name = fullNameController.text;
    params.mobile = mobileNum;
    params.password = passwordController.text;
    params.national_number = nationalNumberController.text;
    params.dob = dobController.text;
    params.passport_number = passportNumberController.text;
    params.passport_expiry_date = passportExpiryDateController.text;
    params.nationality = selectedNationality;
    params.lang = "ar";
    params.gender = selectedGender;
    params.biometricsEnabled = SharedClass.biometricsEnabled;
    params.biometricsKey = SharedClass.biometricsKey;

    (await signupRepository.signUp(params: params)).fold((left) {
      signUpFailure = left;
      signUpStatus = SignUpStatus.error;
      update();
      String? error =
          FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("تسجيل حساب جديد"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if (right.code == "1") {
        signUpStatus = SignUpStatus.success;
        update();
        await localStorageHelper.storeUserData(userModel: right.data!);
        toastification.show(
          context: Get.overlayContext,
          title: const Text("تسجيل حساب جديد"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        signUpFailure = CustomFailure(message: right.message!);
        signUpStatus = SignUpStatus.error;
        update();
        toastification.show(
          context: context,
          title: const Text("تسجيل حساب جديد"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }

  Future<void> getCameraPermission() async {
    final perm = await Permission.camera.request();

    if (perm.isGranted) {
      cameraPermissionStatus = CameraPermissionStatus.granted;
      update();
    } else {
      cameraPermissionStatus = CameraPermissionStatus.denied;
      update();
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Convert MRZ Date to DateTime
  DateTime parseMRZDate(String mrzDate) {
    if (mrzDate == null || mrzDate.length != 6) return DateTime.timestamp();

    try {
      int year = int.parse(mrzDate.substring(0, 2));
      int month = int.parse(mrzDate.substring(2, 4));
      int day = int.parse(mrzDate.substring(4, 6));

      // MRZ years are 2-digit, assume 2000-2099 range
      year += year < 50 ? 2000 : 1900;

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.timestamp();
    }
  }

  // Check if Expiry is Within 6 Months
  bool isExpiringWithinSixMonths(DateTime expiryDate) {
    if (expiryDate == null) return false;

    final now = DateTime.now();
    final sixMonthsFromNow = DateTime(now.year, now.month + 6, now.day);

    return expiryDate.isBefore(sixMonthsFromNow) ||
        expiryDate.isAtSameMomentAs(sixMonthsFromNow);
  }
}
