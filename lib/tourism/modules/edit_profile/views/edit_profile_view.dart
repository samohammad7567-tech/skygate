import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/confirm_password_field_failure.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/password_field_failure.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/edit_profile/views/widgets/avatar_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../global_widgets/custom_form_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  final editProfileController = Get.find<EditProfileController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: true,
          elevation: 0.0,
          title: SvgPicture.asset(
            "assets/images/big-logo.svg",
            width: 105.0.w,
            height: 47.0.h,
          ),
        ),
        body: Container(
          width: 1 * 1.sw,
          height: 1 * 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/seko.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                      GetBuilder<EditProfileController>(
                        init: editProfileController,
                        builder: (editProfileController) {
                          return AvatarWidget(
                            avatarURL: SharedClass.avatar,
                            useAPIAvatar: editProfileController.useAPIAvatar,
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20.0.h)),

                      // Password
                      CustomFormField(
                          hintText: "كلمة المرور",
                          isPassword: true,
                          controller: editProfileController.passwordController,
                          autoValidate: false,
                          validator: (String value) {
                            if (value == "") {
                              return PasswordFieldFailure(PasswordError.empty);
                            }
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 20.0.h)),

                      // Confirm Password
                      CustomFormField(
                          hintText: "تأكيد كلمة المرور",
                          isPassword: true,
                          controller:
                              editProfileController.confirmPasswordController,
                          autoValidate: false,
                          validator: (String value) {
                            if (value == "") {
                              return PasswordFieldFailure(PasswordError.empty);
                            }

                            if (value !=
                                editProfileController.passwordController.text) {
                              return ConfirmPasswordFieldFailure(
                                  ConfirmPasswordFieldError.passwordDoNotMatch);
                            }
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 40.0.h)),

                      // National ID Images
                      SizedBox(
                        width: 360.0.w,
                        child: Text(
                          "تحميل صور الهوية الشخصية",
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await editProfileController
                                  .pickNationalIDImages();
                            },
                            child: Icon(
                              Icons.cloud_upload,
                              size: 45.0,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<EditProfileController>(
                        init: editProfileController,
                        builder: (_) {
                          if (editProfileController
                              .national_id_images!.isNotEmpty) {
                            return SizedBox(
                              width: 350.0.w,
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 350.0.w,
                                    height: 300.0.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(25.0.r),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(editProfileController
                                            .national_id_images![index]),
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        PositionedDirectional(
                                          top: 5.0.h,
                                          end: 5.0.w,
                                          child: InkWell(
                                            onTap: () {
                                              editProfileController
                                                  .national_id_images!
                                                  .removeAt(index);
                                              editProfileController.update();
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0.h));
                                },
                                itemCount: editProfileController
                                    .national_id_images!.length,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20.0.h)),

                      // Passport Images
                      SizedBox(
                        width: 360.0.w,
                        child: Text(
                          "تحميل صور الجواز",
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await editProfileController.pickPassportImages();
                            },
                            child: Icon(
                              Icons.cloud_upload,
                              size: 45.0,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<EditProfileController>(
                        init: editProfileController,
                        builder: (_) {
                          if (editProfileController
                              .passport_images!.isNotEmpty) {
                            return SizedBox(
                              width: 350.0.w,
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: 350.0.w,
                                    height: 300.0.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(25.0.r),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(editProfileController
                                            .passport_images![index]),
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        PositionedDirectional(
                                          top: 5.0.h,
                                          end: 5.0.w,
                                          child: InkWell(
                                            onTap: () {
                                              editProfileController
                                                  .passport_images!
                                                  .removeAt(index);
                                              editProfileController.update();
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0.h));
                                },
                                itemCount: editProfileController
                                    .passport_images!.length,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20.0.h)),

                      // Edit Profile BTN
                      SizedBox(
                        width: 320.0.w,
                        child: CustomButton(
                          onTap: () async {
                            await editProfileController.editProfile(
                                context: context);
                          },
                          btnColor: AppColors.blue,
                          addShadow: false,
                          child: GetBuilder<EditProfileController>(
                            init: editProfileController,
                            builder: (editProfileController) {
                              if (editProfileController.loading) {
                                return LoadingWidget(
                                  color: Colors.white,
                                  size: 20.0,
                                );
                              } else {
                                return Text(
                                  "تعديل الملف الشخصي",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
