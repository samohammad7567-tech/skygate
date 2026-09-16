import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/error_banner.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/change-operation/controllers/change_operation_controller.dart';

class ChoosePaymentMethod2View extends GetView<ChangeOperationController> {
  ChoosePaymentMethod2View({super.key});

  final changeOperationController = Get.find<ChangeOperationController>();

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
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Text(
              "اختر طريقة الدفع",
              style: context.textTheme.displayLarge!.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 40.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
            GetBuilder<ChangeOperationController>(
              init: changeOperationController,
              builder: (changeOperationController) {
                if (changeOperationController.getPaymentMethodsStatus ==
                        GetPaymentMethodsStatus.initial ||
                    changeOperationController.getPaymentMethodsStatus ==
                        GetPaymentMethodsStatus.loading) {
                  return Expanded(
                    child: LoadingWidget(color: AppColors.blue, size: 50.0),
                  );
                } else if (changeOperationController.getPaymentMethodsStatus ==
                    GetPaymentMethodsStatus.error) {
                  return Expanded(
                    child: ErrorPanel(
                      failure:
                          changeOperationController.getPaymentMethodsFailure,
                      onTryAgain: () async {
                        await changeOperationController.getPaymentMethodsData();
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: RadioGroup<String>(
                      groupValue:
                          changeOperationController.selectedPaymentMethod,
                      onChanged: (String? value) {
                        changeOperationController.onPaymentMethodSelect(
                          paymentMethod: value,
                        );
                      },
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            child: ExpansionTile(
                              showTrailingIcon: true,
                              backgroundColor: AppColors.grey,
                              collapsedBackgroundColor: AppColors.grey,
                              title: Text(
                                changeOperationController
                                    .paymentMethodsList[index]
                                    .title!,
                                style: context.textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                changeOperationController
                                    .paymentMethodsList[index]
                                    .subtitle!,
                                style: context.textTheme.titleSmall,
                              ),
                              trailing: CachedNetworkImage(
                                errorWidget:
                                    (BuildContext context, string, obj) {
                                      return SvgPicture.asset(
                                        "assets/images/svgs/big_logo.svg",
                                      );
                                    },
                                imageUrl:
                                    NetworkRoutesControl.imageUrl +
                                    changeOperationController
                                        .paymentMethodsList[index]
                                        .image!,
                                width: 50.0.w,
                              ),
                              leading: Radio<String>(
                                value: changeOperationController
                                    .paymentMethodsList[index]
                                    .title!,
                              ),
                              children: [
                                Text(
                                  changeOperationController
                                      .paymentMethodsList[index]
                                      .details!,
                                  style: context.textTheme.titleSmall,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0.h),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 25.0.h),
                          );
                        },
                        itemCount:
                            changeOperationController.paymentMethodsList.length,
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
            SizedBox(
              width: 150.0.w,
              child: CustomButton(
                onTap: () async {
                  await changeOperationController.payChangeRequest();
                },
                btnColor: AppColors.blue,
                addShadow: false,
                borderRadius: 30.0.r,
                padding: 10.0.r,
                child: GetBuilder<ChangeOperationController>(
                  init: changeOperationController,
                  builder: (changeOperationController) {
                    if (changeOperationController.payChangeRequestStatus ==
                        PayChangeRequestStatus.loading) {
                      return LoadingWidget(color: Colors.white, size: 25.0);
                    } else if (changeOperationController
                            .payChangeRequestStatus ==
                        PayChangeRequestStatus.error) {
                      return ErrorBanner(
                        failure:
                            changeOperationController.payChangeRequestFailure,
                      );
                    } else {
                      return Text(
                        "تأكيد طريقة الدفع",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 36.0.h)),
          ],
        ),
      ),
    );
  }
}
