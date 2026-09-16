import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/core/utils/failures/field_failure/required_field_failure.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/global_widgets/custom_form_field.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/my-trips/controllers/my_trips_controller.dart';

class MyTripsEditView extends GetView<MyTripsController> {
  final myTripsController = Get.find<MyTripsController>();

  MyTripsEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
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
                Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                Text(
                  "طلب تعديل/إلغاء الرحلة",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                Text(
                  "يرجى وصف المطلوب تعديله في الرحلة بدقة:",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                CustomFormField(
                  hintText: "وصف الطلب",
                  isPassword: false,
                  maxLines: 2,
                  obscureText: false,
                  autoValidate: false,
                  controller: myTripsController.ticketEditRequestController,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value != "") {
                      return RequiredFieldFailure();
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                SizedBox(
                  width: 350.0.w,
                  child: CustomButton(
                    onTap: () async {
                      await myTripsController.sendUserMessage(context: context);
                    },
                    btnColor: AppColors.blue,
                    addShadow: false,
                    child: GetBuilder<MyTripsController>(
                      init: myTripsController,
                      builder: (myTripsController) {
                        if (myTripsController.sendMsgLoading) {
                          return LoadingWidget(size: 20.0, color: Colors.white);
                        } else {
                          return Text(
                            "تأكيد الطلب",
                            style: context.textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
