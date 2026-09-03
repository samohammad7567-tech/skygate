import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/confirm_password_field_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/launcher_helper.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/global_widgets/custom_dropdown_field.dart';
import 'package:skygate/tourism/global_widgets/date_picker_form_field.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/failures/field_failure/required_field_failure.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_form_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  final registerController = Get.find<SignupController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/seko.png"),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 75.0.h)),
                Container(
                  width: 390.0.w,
                  decoration: BoxDecoration(
                    color: const Color(0x66CED7E3),
                    borderRadius: BorderRadius.circular(40.0.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 8.0,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(1.0, 1.0),
                        spreadRadius: -2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                      // New Account Text
                      Text(
                        "حساب جديد",
                        style: context.textTheme.displayLarge!.copyWith(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                      // Read Passport Data with Camera Text
                      Text(
                        "اسحب معلوماتك من جواز السفر بواسطة الكاميرا",
                        style: context.textTheme.displayLarge!.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blue,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 8.0.h)),
                      // Camera Scan Button
                      TextButton(
                        onPressed: () async {
                          Get.toNamed(Routes.PASSPORT_SCANNER);
                          registerController.getCameraPermission();
                        },
                        child:
                            SvgPicture.asset("assets/images/passport_scan.svg"),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                      // Divider Line
                      Container(
                        color: AppColors.blue,
                        height: 2.0.h,
                        width: 250.0.w,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                      // Manual Input Text
                      Text(
                        "ادخال يديوي",
                        style: context.textTheme.displayLarge!.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blue,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                      GetBuilder<SignupController>(
                        init: registerController,
                        builder: (registerController) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Full Name
                                CustomFormField(
                                  hintText: "الاسم الثلاثي",
                                  maxLength: 20,
                                  keyboardType: TextInputType.text,
                                  autoValidate: false,
                                  validator: (String value) {
                                    if (value == "") {
                                      return RequiredFieldFailure();
                                    }
                                    return null;
                                  },
                                  controller:
                                      registerController.fullNameController,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 20.0.h)),
                                // Phone Number
                                Container(
                                  width: 290.0.w,
                                  height: 70.0.h,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0.r),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/text-field.png"),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: IntlPhoneField(
                                      textAlign: TextAlign.center,
                                      disableLengthCheck: true,
                                      style: context.textTheme.titleSmall,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller:
                                          registerController.mobileController,
                                      invalidNumberMessage:
                                          "الرقم المدخل غير صحيح",
                                      languageCode: "ar",
                                      decoration: InputDecoration(
                                        hintText: 'رقم الموبايل بلا صفر',
                                        hintStyle: context.textTheme.titleSmall,
                                        border: InputBorder.none,
                                      ),
                                      initialCountryCode: 'SY',
                                      onChanged: (phone) {
                                        registerController.mobileNum =
                                            phone.completeNumber;
                                        debugPrint(phone.completeNumber);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 20.0.h)),
                                // Password
                                CustomFormField(
                                  hintText: "كلمة المرور",
                                  isPassword: true,
                                  maxLength: 30,
                                  controller:
                                      registerController.passwordController,
                                  autoValidate: false,
                                  validator: (String value) {
                                    if (value == "") {
                                      return RequiredFieldFailure();
                                    }
                                  },
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // Confirm Password
                                CustomFormField(
                                  hintText: "تأكيد كلمة المرور",
                                  isPassword: true,
                                  maxLength: 30,
                                  controller: registerController
                                      .confirmPasswordController,
                                  autoValidate: false,
                                  validator: (String value) {
                                    if (value == "") {
                                      return RequiredFieldFailure();
                                    }
                                    if (value !=
                                        registerController
                                            .passwordController.text) {
                                      const passError =
                                          ConfirmPasswordFieldError
                                              .passwordDoNotMatch;
                                      return ConfirmPasswordFieldFailure(
                                          passError);
                                    }
                                  },
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // National Number
                                // CustomFormField(
                                //   hintText: "الرقم الوطني",
                                //   isPassword: false,
                                //   maxLength: 30,
                                //   controller: registerController.nationalNumberController,
                                //   autoValidate: false,
                                //   validator: (String value) {
                                //     if(value == "") {
                                //       return RequiredFieldFailure();
                                //     }
                                //   },
                                // ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // Gender
                                CustomDropdownField(
                                  hintText: "الجنس",
                                  onChanged: (String? value) {
                                    registerController.selectedGender = value!;
                                  },
                                  dropDownList:
                                      registerController.genderItemsList,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // DOB DATE
                                DatePickerFormField(
                                  onDateSelected: (DateTime value) {
                                    registerController.update();
                                  },
                                  hintText: "تاريخ الميلاد",
                                  controller: registerController.dobController,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // Passport Number
                                CustomFormField(
                                  hintText: "رقم جواز السفر",
                                  isPassword: false,
                                  maxLength: 30,
                                  controller: registerController
                                      .passportNumberController,
                                  autoValidate: false,
                                  validator: (String value) {
                                    if (value == "") {
                                      return RequiredFieldFailure();
                                    }
                                  },
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // Passport Expiry Date
                                DatePickerFormField(
                                  onDateSelected: (DateTime value) {
                                    registerController.update();
                                  },
                                  hintText: "تاريخ انتهاء الجواز",
                                  controller: registerController
                                      .passportExpiryDateController,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                // Nationality
                                CustomDropdownField(
                                  hintText: "الجنسية",
                                  onChanged: (String? value) {
                                    registerController.selectedNationality =
                                        value!;
                                  },
                                  dropDownList:
                                      registerController.nationalityItemsList,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 10.0.h)),
                                SizedBox(
                                  width: 244.0.w,
                                  child: CustomButton(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await registerController.signUp(
                                            context: context);
                                      }
                                    },
                                    borderRadius: 30.0,
                                    btnColor: AppColors.blue,
                                    addShadow: false,
                                    child: GetBuilder<SignupController>(
                                      init: registerController,
                                      builder: (registerController) {
                                        if (registerController.signUpStatus ==
                                            SignUpStatus.loading) {
                                          return LoadingWidget(
                                            color: Colors.white,
                                            size: 20.0,
                                          );
                                        } else {
                                          return Text(
                                            "تسجيل",
                                            style: context.textTheme.titleSmall!
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: (SharedClass.biometricsEnabled ==
                                      "false"),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.FINGERPRINT_SETUP);
                                    },
                                    child: Text(
                                      "تفعيل ميزة الدخول بالبصمة",
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        LauncherHelper.launchWhatsapp(
                                            mobile: "+963938159750", msg: "");
                                      },
                                      child: Text(
                                        "الدعم الفني",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        LauncherHelper.launchWhatsapp(
                                            mobile: "+963938159750", msg: "");
                                      },
                                      child: Text(
                                        "المبيعات",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.offAllNamed(Routes.SIGNIN);
                                  },
                                  child: Text(
                                    "تسجيل دخول",
                                    style:
                                        context.textTheme.bodyMedium!.copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
                Text(
                  "* يجب الحضور إلى مكتب الشركة لتأكيد التسجيل",
                  style: context.textTheme.displayLarge!.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 25.0.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
