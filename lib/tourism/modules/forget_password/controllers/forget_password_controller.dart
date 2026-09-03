import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/modules/forget_password/repository/forget_password_repository.dart';
import 'package:skygate/tourism/modules/otp_step/repository/send_otp_repository.dart';
import 'package:skygate/tourism/modules/otp_step/repository/verify_otp_repository.dart';
import 'package:toastification/toastification.dart';
import '../../../routes/app_pages.dart';

enum ForgetPasswordStatus {initial, loading, error, success}
enum SendOTPStatus {initial, loading, error, success}
enum VerifyOTPStatus {initial, loading, error, success}

class ForgetPasswordController extends GetxController {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());
  int resendTimer = 30;
  bool canResend = false;
  String? mobileNum = "";

  RxBool isPassword = true.obs;
  RxBool isConfirmPassword = true.obs;
  bool loading = false;

  late ForgetPasswordRepository forgetPasswordRepository;
  late SendOTPRepository sendOTPRepository;
  late VerifyOTPRepository verifyOTPRepository;

  ForgetPasswordStatus forgetPasswordStatus = ForgetPasswordStatus.initial;
  Failure forgetPasswordFailure = const ServerFailure();
  SendOTPStatus sendOTPStatus = SendOTPStatus.initial;
  Failure sendOTPFailure = const ServerFailure();
  VerifyOTPStatus verifyOTPStatus = VerifyOTPStatus.initial;
  Failure verifyOTPFailure = const ServerFailure();

  @override
  void onInit() {
    super.onInit();
    forgetPasswordRepository = ForgetPasswordRepository();
    sendOTPRepository = SendOTPRepository();
    verifyOTPRepository = VerifyOTPRepository();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }


  Future<void> forgetPassword({BuildContext? context}) async {
    forgetPasswordStatus = ForgetPasswordStatus.loading;
    loading = true;
    update();

    (await forgetPasswordRepository.forgetPassword(mobile: mobileNum!, password: passwordController.text))
        .fold((left) {
          forgetPasswordFailure = left;
          final error = FailureParser.mapFailureToString(failure: left, context: context!);
          toastification.show(
            context: context,
            title: const Text("طلب تغيير كلمة المرور"),
            description: Text(error),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
          loading = false;
          forgetPasswordStatus = ForgetPasswordStatus.error;
          update();
    }, (right) {
          if(right.code == "1") {
            forgetPasswordStatus = ForgetPasswordStatus.success;
            loading = false;
            update();
            toastification.show(
              context: Get.overlayContext,
              title: const Text("طلب تغيير كلمة المرور"),
              description: Text(right.message!),
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 8),
            );
            Get.toNamed(Routes.SIGNIN);
          } else {
            forgetPasswordFailure = CustomFailure(message: right.message!);
            toastification.show(
              context: context,
              title: const Text("طلب تغيير كلمة المرور"),
              description: Text(right.message!),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 8),
            );
            forgetPasswordStatus = ForgetPasswordStatus.error;
            loading = false;
            update();
          }
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (resendTimer == 0) {
        timer.cancel();
        canResend = true;
        update();
      } else {
          resendTimer--;
          update();
      }
    });
  }

  Future<void> resendOtp({BuildContext? context}) async {
    resendTimer = 30;
    canResend = false;
    startTimer();

    sendOTPStatus = SendOTPStatus.loading;
    update();


    (await sendOTPRepository.sendOTP(mobile: mobileNum!))
        .fold((left) {
          sendOTPFailure = left;
      final error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("مرحلة كود التحقق"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
      sendOTPStatus = SendOTPStatus.error;
      update();
    }, (right) {
      if(right.code == "1") {
        sendOTPStatus = SendOTPStatus.success;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("مرحلة كود التحقق"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      } else {
        sendOTPFailure = CustomFailure(message: right.message!);
        toastification.show(
          context: context,
          title: const Text("مرحلة كود التحقق"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        sendOTPStatus = SendOTPStatus.error;
        update();
      }
    });
  }

  Future<void> verifyOtp({BuildContext? context}) async {
    String otp = '';
    for (var controller in otpControllers) {
      otp += controller.text;
    }

    if (otp.length != 6) {
      toastification.show(
        context: context,
        title: const Text("مرحلة كود التحقق"),
        description: const Text("يرجى إدخال جميع خانات الكود."),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
      return;
    }

    verifyOTPStatus = VerifyOTPStatus.loading;
    update();


    (await verifyOTPRepository.verifyOTP(otp: otp,mobile: mobileNum!))
        .fold((left) {
      verifyOTPFailure = left;
      final error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("مرحلة كود التحقق"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
      verifyOTPStatus = VerifyOTPStatus.error;
      update();
    }, (right) async {
      if(right.code == "1") {
        verifyOTPStatus = VerifyOTPStatus.success;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("مرحلة كود التحقق"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        await forgetPassword(context: context);
      } else {
        verifyOTPFailure = CustomFailure(message: right.message!);
        toastification.show(
          context: context,
          title: const Text("مرحلة كود التحقق"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        verifyOTPStatus = VerifyOTPStatus.error;
        update();
      }
    });

  }

  Future<void> sendOtp({BuildContext? context}) async {
    resendTimer = 30;
    canResend = false;
    startTimer();

    sendOTPStatus = SendOTPStatus.loading;
    update();


    (await sendOTPRepository.sendOTP(mobile: mobileNum!))
        .fold((left) {
      sendOTPFailure = left;
      final error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("مرحلة كود التحقق"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
      sendOTPStatus = SendOTPStatus.error;
      update();
    }, (right) {
      if(right.code == "1") {
        sendOTPStatus = SendOTPStatus.success;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("مرحلة كود التحقق"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        Get.toNamed(Routes.OTP_VERIFY);
      } else {
        sendOTPFailure = CustomFailure(message: right.message!);
        toastification.show(
          context: context,
          title: const Text("مرحلة كود التحقق"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        sendOTPStatus = SendOTPStatus.error;
        update();
      }
    });
  }

}
