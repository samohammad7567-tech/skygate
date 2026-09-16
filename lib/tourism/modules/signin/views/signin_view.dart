import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/required_field_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/launcher_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/custom_form_field.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  final loginController = Get.find<SigninController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SigninView({super.key});

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
                      "تسجيل الدخول",
                      style: context.textTheme.displayLarge!.copyWith(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blue,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                    Form(
                      key: _formKey,
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
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: IntlPhoneField(
                                textAlign: TextAlign.center,
                                disableLengthCheck: true,
                                style: context.textTheme.titleSmall,
                                textAlignVertical: TextAlignVertical.center,
                                controller: loginController.mobileController,
                                invalidNumberMessage: "الرقم المدخل غير صحيح",
                                languageCode: "ar",
                                decoration: InputDecoration(
                                  hintText: 'رقم الموبايل بلا صفر',
                                  hintStyle: context.textTheme.titleSmall!
                                      .copyWith(fontSize: 12.0),
                                  border: InputBorder.none,
                                ),
                                initialCountryCode: 'SY',
                                onChanged: (phone) {
                                  loginController.mobileNum =
                                      phone.completeNumber;
                                  debugPrint(phone.completeNumber);
                                },
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                          CustomFormField(
                            hintText: "كلمة المرور",
                            isPassword: true,
                            maxLength: 30,
                            controller: loginController.passwordController,
                            autoValidate: false,
                            validator: (String value) {
                              if (value == "") {
                                return RequiredFieldFailure();
                              }
                              return null;
                            },
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 17.0.h)),
                          SizedBox(
                            width: 200.0.w,
                            child: CustomButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  await loginController.signIn(
                                    context: context,
                                  );
                                }
                              },
                              borderRadius: 30.0,
                              btnColor: AppColors.blue,
                              addShadow: false,
                              child: GetBuilder<SigninController>(
                                init: loginController,
                                builder: (loginController) {
                                  if (loginController.signInStatus ==
                                      SignInStatus.loading) {
                                    return LoadingWidget(
                                      color: Colors.white,
                                      size: 20.0,
                                    );
                                  } else {
                                    return Text(
                                      "تسجيل الدخول",
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
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.FORGET_PASSWORD);
                            },
                            child: Text(
                              "هل نسيت كلمة المرور؟",
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5.0.h)),

                          Visibility(
                            visible: (SharedClass.biometricsEnabled == "1"),
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FINGERPRINT_LOGIN);
                              },
                              child: Text(
                                "الدخول باستخدام البصمة",
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 5.0.h)),
                          SizedBox(
                            width: 112.0.w,
                            height: 25.0.h,
                            child: CustomButton(
                              onTap: () {
                                Get.offAllNamed(Routes.SIGNUP);
                              },
                              borderRadius: 30.0,
                              btnColor: Colors.white,
                              padding: 0.0,
                              addShadow: false,
                              child: Text(
                                "حساب جديد",
                                style: context.textTheme.titleSmall!.copyWith(
                                  fontSize: 12.0,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  LauncherHelper.launchWhatsapp(
                                    mobile: "+963938159750",
                                    msg: "",
                                  );
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
                                    mobile: "+963935278201",
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
