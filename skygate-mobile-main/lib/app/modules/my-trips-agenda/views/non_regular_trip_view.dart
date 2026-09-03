import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/error_panel.dart';
import 'package:sky_gate/app/global_widgets/gesture_page.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import 'package:sky_gate/app/modules/my-trips-agenda/controllers/my_trips_agenda_controller.dart';

class NonRegularTripView extends GetView<MyTripsAgendaController> {
  NonRegularTripView({super.key});

  final myTripsAgendaController = Get.find<MyTripsAgendaController>();

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
                Padding(padding: EdgeInsets.only(bottom: 40.0.h)),
                // Body Title
                Text(
                  "نتائج البحث",
                  style: context.textTheme.titleMedium!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                Container(
                  width: 376.0.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text("11:30", style: context.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),),
                              Text(
                                "${myTripsAgendaController.selectedDeparturePlace}",
                                style: context.textTheme.titleSmall,
                              ),
                              // Text("بانتظار تصحيح\n بيانات المطارات", style: context.textTheme.titleSmall,)
                            ],
                          ),
                          Image.asset(
                            "assets/images/plane.png",
                            width: 100.0.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text("11:30", style: context.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),),
                              Text(
                                "${myTripsAgendaController.selectedArrivalPlace}",
                                style: context.textTheme.titleSmall,
                              ),
                              // Text("بانتظار تصحيح\n بيانات المطارات", style: context.textTheme.titleSmall,)
                            ],
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                      Divider(
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "الدرجة ${myTripsAgendaController.selectedTripLevel}",
                                style: context.textTheme.titleSmall,
                              ),
                              Text(
                                "تاريخ المغادرة \n تاريخ العودة",
                                style: context.textTheme.titleSmall,
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "سيتم مرسلتكم من قبل\n موظف المكتب لارسال\n سعر أقرب رحلة لطلبكم",
                                style: context.textTheme.titleSmall,
                                maxLines: 4,
                                softWrap: true,
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: (myTripsAgendaController.isOneWay == true),
                            child: Text(
                              "${myTripsAgendaController.departureDateController.text}",
                              style: context.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                (myTripsAgendaController.isOneWay == false),
                            child: Text(
                              "${myTripsAgendaController.departureDateController.text}   |   ${myTripsAgendaController.returnDateController.text}",
                              style: context.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                      SizedBox(
                        width: 222.0.w,
                        child: CustomButton(
                          onTap: () async {
                            await myTripsAgendaController.submitBookingRequest(
                                isRegularTrip: "0", regularTripID: "-1");
                          },
                          btnColor: AppColors.blue,
                          addShadow: false,
                          borderRadius: 15.0.r,
                          padding: 10.0.r,
                          child: GetBuilder<MyTripsAgendaController>(
                            init: myTripsAgendaController,
                            builder: (myTripsAgendaController) {
                              if (myTripsAgendaController
                                      .submitBookingRequestStatus ==
                                  SubmitBookingRequestStatus.loading) {
                                return LoadingWidget(
                                  size: 25.0,
                                  color: Colors.white,
                                );
                              } else if (myTripsAgendaController
                                      .submitBookingRequestStatus ==
                                  SubmitBookingRequestStatus.error) {
                                return ErrorPanel(
                                    failure: myTripsAgendaController
                                        .submitBookingRequestFailure,
                                    onTryAgain: () async {
                                      myTripsAgendaController
                                          .submitBookingRequest(
                                              isRegularTrip: "0",
                                              regularTripID: "-1");
                                    });
                              } else {
                                return Text(
                                  "طلب حجز",
                                  style:
                                      context.textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                    ],
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
