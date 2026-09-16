import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/helpers/launcher_helper.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/welcome_login_controller.dart';

class WelcomeLoginView extends GetView<WelcomeLoginController> {
  const WelcomeLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Image.asset(
            "assets/images/pngs/welcome_login.png",
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          PositionedDirectional(
            top: 242.0.h,
            child: SvgPicture.asset("assets/images/svgs/big_logo.svg"),
          ),
          PositionedDirectional(
            top: 466.0.h,
            child: Column(
              children: [
                SizedBox(
                  width: 298.0.w,
                  child: CustomButton(
                    onTap: () {
                      Get.offAllNamed(Routes.SIGNIN);
                    },
                    btnColor: AppColors.blue,
                    padding: 20.0,
                    addShadow: true,
                    borderRadius: 30.0,
                    child: Text(
                      "تسجيل الدخول",
                      style: context.textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                SizedBox(
                  width: 298.0.w,
                  child: CustomButton(
                    onTap: () {
                      Get.offAllNamed(Routes.SIGNUP);
                    },
                    btnColor: Colors.white,
                    padding: 20.0,
                    addShadow: true,
                    borderRadius: 30.0,
                    child: Text(
                      "حساب جديد",
                      style: context.textTheme.displayMedium!.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                SizedBox(
                  width: 298.0.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 136.0.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0.r),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF4594F1),
                              Color(0xFF22509E),
                            ], // Your gradient colors
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: CustomButton(
                          onTap: () {
                            LauncherHelper.launchWhatsapp(
                              mobile: "+963935278201",
                              msg: "",
                            );
                          },
                          btnColor: Colors.transparent,
                          padding: 10.0,
                          addShadow: false,
                          borderRadius: 30.0,
                          child: Text(
                            "المبيعات",
                            style: context.textTheme.displaySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 136.0.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4594F1),
                              Color(0xFF22509E),
                            ], // Your gradient colors
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: CustomButton(
                          onTap: () {
                            LauncherHelper.launchWhatsapp(
                              mobile: "+963938159750",
                              msg: "",
                            );
                          },
                          btnColor: Colors.transparent,
                          padding: 10.0,
                          addShadow: true,
                          borderRadius: 30.0,
                          child: Text(
                            "الدعم الفني",
                            style: context.textTheme.displaySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                  icon: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
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
    );
  }
}
