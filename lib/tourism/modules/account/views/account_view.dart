import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/global_widgets/custom_alert_dialog.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/language/language_controller.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  final accountController = Get.find<AccountController>();
  final languageController = Get.find<LanguageController>();

  AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
          Text(
            "حسابي",
            style: context.textTheme.displayLarge!.copyWith(
              color: AppColors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 40.0,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
          Container(
            width: 120.0.w,
            height: 120.0.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1.0,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Image.asset("assets/images/pngs/person.png"),
          ),
          Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.EDIT_PROFILE);
            },
            child: Container(
              width: 360.0.w,
              padding: EdgeInsets.all(18.0.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
                color: Color(0x66CED7E3),
              ),
              child: Text(
                "المعلومات الشخصية",
                style: context.textTheme.titleSmall,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          Visibility(
            visible:
                (SharedClass.biometricsEnabled == "0" ||
                SharedClass.biometricsEnabled == ""),
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.FINGERPRINT_SETUP);
              },
              child: Container(
                width: 360.0.w,
                padding: EdgeInsets.all(18.0.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0.r),
                  color: Color(0x66CED7E3),
                ),
                child: Text(
                  "تفعيل الدخول بالبصمة",
                  style: context.textTheme.titleSmall,
                ),
              ),
            ),
          ),
          Visibility(
            visible:
                (SharedClass.biometricsEnabled == "false" ||
                SharedClass.biometricsEnabled == ""),
            child: Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.TRAVEL_INFO);
            },
            child: Container(
              width: 360.0.w,
              padding: EdgeInsets.all(18.0.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
                color: const Color(0x66CED7E3),
              ),
              child: Text(
                "معلومات عن السفر",
                style: context.textTheme.titleSmall,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.TRAVEL_ALLOWED_COUNTRIES);
            },
            child: Container(
              width: 360.0.w,
              padding: EdgeInsets.all(18.0.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
                color: Color(0x66CED7E3),
              ),
              child: Text(
                "الدول التي يمكن السفر لها",
                style: context.textTheme.titleSmall,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.MY_BOOKINGS_REQUESTS);
            },
            child: Container(
              width: 360.0.w,
              padding: EdgeInsets.all(18.0.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
                color: const Color(0x66CED7E3),
              ),
              child: Text("طلباتي", style: context.textTheme.titleSmall),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          InkWell(
            onTap: () async {
              await accountController.logoutUser();
            },
            child: Container(
              width: 360.0.w,
              padding: EdgeInsets.all(18.0.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
                color: const Color(0x6622509E),
              ),
              child: GetBuilder<AccountController>(
                init: accountController,
                builder: (accountController) {
                  if (accountController.logoutLoading!.value) {
                    return LoadingWidget(color: AppColors.blue, size: 20.0);
                  } else {
                    return Text(
                      "تسجيل الخروج",
                      style: context.textTheme.titleSmall!.copyWith(
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
          InkWell(
            onTap: () async {
              await CustomAlertDialog.show(
                context: context,
                title: "تأكيد حذف الحساب",
                message: "هل تريد بالفعل حذف حسابك نهائياً ؟",
                positiveButtonText: "موافق",
                negativeButtonText: "إلغاء",
                onPositivePressed: () async {
                  await accountController.deleteUserProfile();
                },
              );
            },
            child: Container(
              width: 360.0.w,
              padding: EdgeInsets.all(18.0.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0.r),
                color: const Color(0x6622509E),
              ),
              child: Text(
                "حذف الحساب",
                style: context.textTheme.titleSmall!.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
        ],
      ),
    );
  }
}
