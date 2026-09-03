import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final homeController = Get.find<HomeController>();

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
                title: SvgPicture.asset("assets/images/big-logo.svg",width: 105.0.w,height: 47.0.h,),
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
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          color: AppColors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Home
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
                                      color: (homeController.currentIndex==0)? Colors.white:Colors.transparent,
                                    ),
                                    child: (homeController.currentIndex==0)? SvgPicture.asset("assets/images/home-selected.svg")
                                     : SvgPicture.asset("assets/images/home-selected.svg", color: Colors.white,),
                                  ),
                                  Text("الرئيسية", style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),)
                                ],
                              ),
                            ),
                            // Trips
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
                                      color: (homeController.currentIndex==1)? Colors.white:Colors.transparent,
                                    ),
                                    child: (homeController.currentIndex==1)? SvgPicture.asset("assets/images/trips-unselected.svg",color: AppColors.blue,fit: BoxFit.scaleDown,)
                                        : SvgPicture.asset("assets/images/trips-unselected.svg"),
                                  ),
                                  Text("رحلاتي", style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),)
                                ],
                              ),
                            ),
                            // Support
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
                                      color: (homeController.currentIndex==2)? Colors.white:Colors.transparent,
                                    ),
                                    child: (homeController.currentIndex==2)? SvgPicture.asset("assets/images/support-unselected.svg",color: AppColors.blue,fit: BoxFit.scaleDown,)
                                        : SvgPicture.asset("assets/images/support-unselected.svg"),
                                  ),
                                  Text("الدعم", style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),)
                                ],
                              ),
                            ),
                            // Notifications
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
                                      color: (homeController.currentIndex==3)? Colors.white:Colors.transparent,
                                    ),
                                    child: (homeController.currentIndex==3)? Image.asset("assets/images/notification.png"):Image.asset("assets/images/notification-white.png"),
                                  ),
                                  Text("التنبيهات", style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),)
                                ],
                              ),
                            ),
                            // Account
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
                                      color: (homeController.currentIndex==4)? Colors.white:Colors.transparent,
                                    ),
                                    child: (homeController.currentIndex==4)? SvgPicture.asset("assets/images/account-unselected.svg",color: AppColors.blue,fit: BoxFit.scaleDown,)
                                        : SvgPicture.asset("assets/images/account-unselected.svg"),
                                  ),
                                  Text("حسابي", style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  );
                  },
              ),
            );
        },
    );
  }
}
