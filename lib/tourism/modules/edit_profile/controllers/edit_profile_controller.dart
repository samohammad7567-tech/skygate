import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/tourism/core/utils/helpers/local_storage_helper.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/modules/edit_profile/params/edit_profile_params.dart';
import 'package:skygate/tourism/modules/edit_profile/repository/edit_profile_repository.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import 'package:toastification/toastification.dart';
import '../../../core/utils/failures/base_failure.dart';
import '../../../core/utils/failures/http/http_failure.dart';
import '../../../data/shared/shared_class.dart';
import 'dart:io';

enum EditUserProfileStatus { initial, loading, error, success }

class EditProfileController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  EditUserProfileStatus editProfileStatus = EditUserProfileStatus.initial;
  Failure editProfileFailure = const ServerFailure();

  late EditProfileRepository editProfileRepository;
  late LocalStorageHelper localStorageHelper;

  bool useFileAvatar = false;
  bool useAPIAvatar = false;
  bool loading = false;

  List<File>? national_id_images = [];
  List<File>? passport_images = [];
  File? avatar_pic;

  Directory? dir;

  @override
  void onInit() async {
    super.onInit();
    if (SharedClass.avatar == "") {
      useAPIAvatar = false;
    } else {
      useAPIAvatar = true;
    }
    editProfileRepository = EditProfileRepository();
    localStorageHelper = Get.find<LocalStorageHelper>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> editProfile({BuildContext? context}) async {
    loading = true;
    update();

    EditProfileParams params = EditProfileParams();

    params.password = passwordController.text;
    params.national_id_images = national_id_images;
    params.passport_images = passport_images;

    (await editProfileRepository.editUserProfile(
            params: params, avatar_image: avatar_pic))
        .fold(
      (l) {
        loading = false;
        update();
        final error =
            FailureParser.mapFailureToString(failure: l, context: context!);
        toastification.show(
          context: Get.overlayContext,
          title: const Text("تحديث المعلومات الشخصية"),
          description: Text(error),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      },
      (r) async {
        loading = false;
        update();
        if (r.code == "1") {
          toastification.show(
            context: Get.overlayContext,
            title: const Text("تحديث المعلومات الشخصية"),
            description: Text(r.message!),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
          Get.offAllNamed(Routes.HOME);
        } else {
          toastification.show(
            context: Get.overlayContext,
            title: const Text("تحديث المعلومات الشخصية"),
            description: Text(r.message!),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
        }
      },
    );
  }

  void directUpdateImage(File? file) async {
    if (file == null) return;

    avatar_pic = file;
    update();
  }

  Future<void> pickNationalIDImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      pickedFiles.forEach((element) {
        national_id_images!.add(File(element.path));
      });
      update();
    }
  }

  Future<void> pickPassportImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      pickedFiles.forEach((element) {
        passport_images!.add(File(element.path));
      });
      update();
    }
  }
}
