import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/confirm_password_field_failure.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/required_field_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/launcher_helper.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_form_field.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  final forgetPasswordController = Get.find<ForgetPasswordController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          children: [
            Image.asset(
              "assets/images/pngs/login_img.png",
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            PositionedDirectional(
              top: 317.0.h,
              child: Container(
                width: 341.0.w,
                decoration: BoxDecoration(
                  color: const Color(0xCCF7F8FA),
                  borderRadius: BorderRadius.circular(15.0.r),
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
                    Text(
                      "تغيير كلمة المرور",
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 290.0.w,
                            height: 70.0.h,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0.r),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/pngs/text_field.png",
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            child: IntlPhoneField(
                              textAlign: TextAlign.center,
                              disableLengthCheck: true,
                              style: context.textTheme.titleSmall,
                              textAlignVertical: TextAlignVertical.center,
                              controller:
                                  forgetPasswordController.mobileController,
                              invalidNumberMessage: "الرقم المدخل غير صحيح",
                              languageCode: "ar",
                              decoration: InputDecoration(
                                hintText: 'رقم الموبايل بلا صفر',
                                hintStyle: context.textTheme.titleSmall,
                                border: InputBorder.none,
                              ),
                              initialCountryCode: 'SY',
                              onChanged: (phone) {
                                forgetPasswordController.mobileNum =
                                    phone.completeNumber;
                                debugPrint(phone.completeNumber);
                              },
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                          CustomFormField(
                            hintText: "كلمة المرور الجديدة",
                            isPassword: true,
                            maxLength: 30,
                            controller:
                                forgetPasswordController.passwordController,
                            autoValidate: false,
                            validator: (String value) {
                              if (value == "") {
                                return RequiredFieldFailure();
                              } else {
                                return null;
                              }
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                          CustomFormField(
                            hintText: "تأكيد كلمة المرور الجديدة",
                            isPassword: true,
                            maxLength: 30,
                            controller: forgetPasswordController
                                .confirmPasswordController,
                            autoValidate: false,
                            validator: (String value) {
                              if (value == "") {
                                return RequiredFieldFailure();
                              }
                              if (value !=
                                  forgetPasswordController
                                      .confirmPasswordController
                                      .text) {
                                const passError = ConfirmPasswordFieldError
                                    .passwordDoNotMatch;
                                return ConfirmPasswordFieldFailure(passError);
                              } else {
                                return null;
                              }
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 17.0.h)),
                          SizedBox(
                            width: 160.0.w,
                            child: CustomButton(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  forgetPasswordController.sendOtp(
                                    context: context,
                                  );
                                }
                              },
                              borderRadius: 30.0,
                              btnColor: AppColors.blue,
                              addShadow: false,
                              child: GetBuilder<ForgetPasswordController>(
                                init: forgetPasswordController,
                                builder: (_) {
                                  if (forgetPasswordController.loading) {
                                    return LoadingWidget(
                                      color: Colors.white,
                                      size: 20.0,
                                    );
                                  } else {
                                    return Text(
                                      "تأكيد تغيير كلمة المرور",
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5.0.h)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  LauncherHelper.launchWhatsapp(
                                    mobile: "+963991805020",
                                    msg: "",
                                  );
                                },
                                child: Text(
                                  "الدعم الفني",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  LauncherHelper.launchWhatsapp(
                                    mobile: "+963991805020",
                                    msg: "",
                                  );
                                },
                                child: Text(
                                  "المبيعات",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              top: 858.0.h,
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.globe, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
