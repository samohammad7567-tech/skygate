import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/modules/last-promotions/views/widgets/promotion_card.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/last_promotions_controller.dart';

class LastPromotionsView extends GetView<LastPromotionsController> {
  LastPromotionsView({super.key});
  final lastPromotionsController = Get.find<LastPromotionsController>();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              Text(
                "آخر العروض",
                style: context.textTheme.displayLarge!.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 40.0,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
              ListView.separated(
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.PROMOTION_DETAILS, arguments: {
                        "id": lastPromotionsController.promotionsList[index].id
                      });
                    },
                    child: PromotionCard(
                      to: lastPromotionsController.promotionsList[index].to,
                      from: lastPromotionsController.promotionsList[index].from,
                      image:
                          lastPromotionsController.promotionsList[index].image,
                      price:
                          lastPromotionsController.promotionsList[index].cost,
                      currency: lastPromotionsController
                          .promotionsList[index].currency,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.only(bottom: 22.0.h));
                },
                itemCount: lastPromotionsController.promotionsList.length,
                shrinkWrap: true,
              ),
              Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
