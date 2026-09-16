import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final homeController = Get.find<HomeController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: homeController,
      builder: (homeController) {
        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: false,
          extendBody: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            centerTitle: true,
            elevation: 0.0,
            title: SvgPicture.asset(
              "assets/images/svgs/big_logo.svg",
              width: 105.0.w,
              height: 47.0.h,
            ),
          ),
          body: Container(
            width: 1 * 1.sw,
            height: 1 * 1.sh,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/pngs/seko.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: homeController.getCurrentTabView(),
          ),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: GetBuilder<HomeController>(
            init: homeController,
            builder: (homeController) {
              return SizedBox(
                height: 86.0.h,
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: AppColors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          homeController.changeCurrentIndex(index: 0);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 56.0.w,
                              height: 40.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0.r),
                                color: (homeController.currentIndex == 0)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: (homeController.currentIndex == 0)
                                  ? SvgPicture.asset(
                                      "assets/images/svgs/home_selected.svg",
                                    )
                                  : SvgPicture.asset(
                                      "assets/images/svgs/home_selected.svg",
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                            ),
                            Text(
                              "الرئيسية",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          homeController.changeCurrentIndex(index: 1);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 56.0.w,
                              height: 40.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0.r),
                                color: (homeController.currentIndex == 1)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: (homeController.currentIndex == 1)
                                  ? SvgPicture.asset(
                                      "assets/images/svgs/trips_unselected.svg",
                                      colorFilter: ColorFilter.mode(
                                        AppColors.blue,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.scaleDown,
                                    )
                                  : SvgPicture.asset(
                                      "assets/images/svgs/trips_unselected.svg",
                                    ),
                            ),
                            Text(
                              "رحلاتي",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          homeController.changeCurrentIndex(index: 2);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 56.0.w,
                              height: 40.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0.r),
                                color: (homeController.currentIndex == 2)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: (homeController.currentIndex == 2)
                                  ? SvgPicture.asset(
                                      "assets/images/svgs/support_unselected.svg",
                                      colorFilter: ColorFilter.mode(
                                        AppColors.blue,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.scaleDown,
                                    )
                                  : SvgPicture.asset(
                                      "assets/images/svgs/support_unselected.svg",
                                    ),
                            ),
                            Text(
                              "الدعم",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          homeController.changeCurrentIndex(index: 3);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 56.0.w,
                              height: 40.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0.r),
                                color: (homeController.currentIndex == 3)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: (homeController.currentIndex == 3)
                                  ? Image.asset(
                                      "assets/images/pngs/notification.png",
                                    )
                                  : Image.asset(
                                      "assets/images/pngs/notification_white.png",
                                    ),
                            ),
                            Text(
                              "التنبيهات",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          homeController.changeCurrentIndex(index: 4);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 56.0.w,
                              height: 40.0.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0.r),
                                color: (homeController.currentIndex == 4)
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: (homeController.currentIndex == 4)
                                  ? SvgPicture.asset(
                                      "assets/images/svgs/account_unselected.svg",
                                      colorFilter: ColorFilter.mode(
                                        AppColors.blue,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.scaleDown,
                                    )
                                  : SvgPicture.asset(
                                      "assets/images/svgs/account_unselected.svg",
                                    ),
                            ),
                            Text(
                              "حسابي",
                              style: context.textTheme.titleSmall!.copyWith(
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
            },
          ),
        );
      },
    );
  }
}
