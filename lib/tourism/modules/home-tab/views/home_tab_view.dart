import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/routes/app_pages.dart';
import '../controllers/home_tab_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTabView extends GetView<HomeTabController> {
  final homeTabController = Get.find<HomeTabController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "آخر العروض",
                style: context.textTheme.titleMedium!.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w400,
                  fontSize: 24.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (homeTabController.promotionsList.isNotEmpty) {
                    Get.toNamed(Routes.LAST_PROMOTIONS);
                  }
                },
                child: Text(
                  "المزيد",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
        GetBuilder<HomeTabController>(
          init: homeTabController,
          builder: (homeTabController) {
            if (homeTabController.getPromotionsDataStatus ==
                    GetPromotionsDataStatus.loading ||
                homeTabController.getPromotionsDataStatus ==
                    GetPromotionsDataStatus.initial) {
              return Expanded(
                child: LoadingWidget(
                  color: AppColors.blue,
                  size: 50.0,
                ),
              );
            } else if (homeTabController.getPromotionsDataStatus ==
                GetPromotionsDataStatus.error) {
              return ErrorPanel(
                failure: homeTabController.getPromotionsDataFailure,
                onTryAgain: () async {
                  await homeTabController.getPromotionsData();
                },
              );
            } else {
              if (homeTabController.promotionsList.isEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.find_in_page,
                        color: AppColors.blue,
                        size: 50.0,
                      ),
                      Text(
                        tr("noRecordsFound"),
                        style: context.textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: 520.0.h,
                  child: CarouselSlider.builder(
                    itemCount: homeTabController.promotionsList.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      return InkWell(
                        onTap: () {
                          Get.toNamed(Routes.PROMOTION_DETAILS, arguments: {
                            "id": homeTabController.promotionsList[itemIndex].id
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(27.0.r),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: NetworkRoutesControl.imageUrl +
                                    homeTabController
                                        .promotionsList[itemIndex].image!,
                                fit: BoxFit.fitHeight,
                                height: 200.0.h,
                              ),
                              PositionedDirectional(
                                bottom: 0.0,
                                child: Container(
                                  height: 66.0.h,
                                  width: 348.0.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27.0.r),
                                    color: Color(0xBFFFFFFF),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "رحلة",
                                        style: context.textTheme.titleSmall!
                                            .copyWith(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                      Text(
                                        "${homeTabController.promotionsList[itemIndex].from} - ${homeTabController.promotionsList[itemIndex].to}",
                                        style: context.textTheme.titleSmall!
                                            .copyWith(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      aspectRatio: 0.8,
                      initialPage: 2,
                    ),
                  ),
                );
              }
            }
          },
        ),
        Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.AIRPORT_TAXI);
              },
              child: SvgPicture.asset("assets/images/svgs/taxi_btn.svg"),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.MY_TRIPS_AGENDA);
              },
              child: SvgPicture.asset("assets/images/svgs/trip_btn.svg"),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.AIRPORT_MAP);
              },
              child: SvgPicture.asset("assets/images/svgs/airport_map_btn.svg"),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 15.0.h)),
      ],
    );
  }
}
