import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/core/utils/helpers/launcher_helper.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/gesture_page.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import 'package:sky_gate/app/modules/forget_password/controllers/forget_password_controller.dart';

class OTPCodeView extends GetView<ForgetPasswordController> {
  OTPCodeView({super.key});

  final forgetPasswordController = Get.find<ForgetPasswordController>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
              "assets/images/login-img.png",
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            PositionedDirectional(
              top: 317.0.h,
              child: Container(
                width: 370.0.w,
                decoration: BoxDecoration(
                  color: const Color(0xCCF7F8FA),
                  borderRadius: BorderRadius.circular(15.0.r),
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 50.0.h)),
                    Text(
                      "إدخال كود التحقق",
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                    Text(
                      "يرجى إدخال الكود المرسل إليك عبر الإشعارات.",
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // OTP Input Fields
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.ltr,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: 45,
                                  child: TextField(
                                    controller: forgetPasswordController
                                        .otpControllers[index],
                                    focusNode: forgetPasswordController
                                        .otpFocusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.blue),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.length == 1 && index < 5) {
                                        // Move focus to the next field when a digit is entered (left-to-right)
                                        FocusScope.of(context).requestFocus(
                                            forgetPasswordController
                                                .otpFocusNodes[index + 1]);
                                      } else if (value.isEmpty && index > 0) {
                                        // Move focus to the previous field when a digit is deleted (right-to-left)
                                        FocusScope.of(context).requestFocus(
                                            forgetPasswordController
                                                .otpFocusNodes[index - 1]);
                                      }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 17.0.h)),
                          // Confirm Button
                          SizedBox(
                            width: 160.0.w,
                            child: CustomButton(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  forgetPasswordController.verifyOtp(
                                      context: context);
                                }
                              },
                              borderRadius: 30.0,
                              btnColor: AppColors.blue,
                              addShadow: false,
                              child: GetBuilder<ForgetPasswordController>(
                                init: forgetPasswordController,
                                builder: (_) {
                                  if (forgetPasswordController
                                          .verifyOTPStatus ==
                                      VerifyOTPStatus.loading) {
                                    return LoadingWidget(
                                      color: Colors.white,
                                      size: 20.0,
                                    );
                                  } else {
                                    return Text(
                                      "تأكيد رمز التحقق",
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5.0.h)),
                          // Resend OTP Section
                          GetBuilder<ForgetPasswordController>(
                            init: forgetPasswordController,
                            builder: (forgetPasswordController) {
                              return Center(
                                child: forgetPasswordController.canResend
                                    ? TextButton(
                                        onPressed: () async {
                                          await forgetPasswordController
                                              .resendOtp(context: context);
                                        },
                                        child: Text(
                                          'إعادة إرسال كود التحقق',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      )
                                    : Text(
                                        "يمكنك الإرسال خلال " +
                                            forgetPasswordController.resendTimer
                                                .toString() +
                                            " ثانية",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                              );
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5.0.h)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  LauncherHelper.launchWhatsapp(
                                      mobile: "+963991805020", msg: "");
                                },
                                child: Text(
                                  "الدعم الفني",
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  LauncherHelper.launchWhatsapp(
                                      mobile: "+963991805020", msg: "");
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
                          )
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
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.globe,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
