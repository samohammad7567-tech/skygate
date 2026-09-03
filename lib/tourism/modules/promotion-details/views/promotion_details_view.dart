import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';

import '../controllers/promotion_details_controller.dart';

class PromotionDetailsView extends GetView<PromotionDetailsController> {
  PromotionDetailsView({super.key});

  final promotionDetailsController = Get.find<PromotionDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      extendBody: true,
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
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              Container(
                width: 400.0.w,
                height: 366.0.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(NetworkRoutesControl.imageUrl +
                        promotionDetailsController.promotion.image!),
                  ),
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 23.0.w),
                  child: Text(
                    "${promotionDetailsController.promotion.from} - ${promotionDetailsController.promotion.to}",
                    style: context.textTheme.displaySmall!.copyWith(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 23.0.w),
                  child: Text(
                    "الوصف :",
                    style: context.textTheme.displaySmall!.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 23.0.w, left: 23.0.w),
                  child: Text(
                    "${promotionDetailsController.promotion.description}",
                    style: context.textTheme.displaySmall!.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 70.0.h)),
              Text(
                "ابتداء من ${promotionDetailsController.promotion.cost} ${promotionDetailsController.promotion.currency}",
                style: context.textTheme.displaySmall!.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
              SizedBox(
                width: 220.0.w,
                child: CustomButton(
                  onTap: () async {
                    await promotionDetailsController.sendMessage(
                        context: context);
                  },
                  borderRadius: 25.0,
                  btnColor: AppColors.blue,
                  addShadow: false,
                  child: GetBuilder<PromotionDetailsController>(
                      init: promotionDetailsController,
                      builder: (promotion) {
                        if (promotionDetailsController.sendMsgLoading) {
                          return LoadingWidget(
                            color: Colors.white,
                            size: 20.0,
                          );
                        } else {
                          return Text(
                            "احجز الآن",
                            style: context.textTheme.displaySmall!.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
