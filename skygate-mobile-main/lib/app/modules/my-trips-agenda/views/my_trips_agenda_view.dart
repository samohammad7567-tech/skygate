import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/error_banner.dart';
import 'package:sky_gate/app/global_widgets/error_panel.dart';
import 'package:sky_gate/app/global_widgets/gesture_page.dart';
import 'package:sky_gate/app/global_widgets/loading_widget.dart';
import 'package:sky_gate/app/global_widgets/regular_trips_datepicker.dart';
import 'package:sky_gate/app/global_widgets/regular_trips_dropdownfield.dart';
import 'package:toastification/toastification.dart';
import '../controllers/my_trips_agenda_controller.dart';

class MyTripsAgendaView extends GetView<MyTripsAgendaController> {
  MyTripsAgendaView({super.key});

  final myTripsAgendaController = Get.find<MyTripsAgendaController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GesturePage(
      gestureChild: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        extendBody: true,
        resizeToAvoidBottomInset: true,
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
                // Two Choices Buttons
                GetBuilder<MyTripsAgendaController>(
                  init: myTripsAgendaController,
                  builder: (myTripsAgendaController) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150.0.w,
                          child: CustomButton(
                            child: Text(
                              "ذهاب",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: (myTripsAgendaController.isOneWay)
                                    ? Colors.white
                                    : AppColors.blue,
                              ),
                            ),
                            onTap: () {
                              myTripsAgendaController.setTripDirection(
                                  oneWay: true);
                            },
                            btnColor: (myTripsAgendaController.isOneWay)
                                ? AppColors.blue
                                : Colors.white,
                            addShadow: false,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w)),
                        SizedBox(
                          width: 150.0.w,
                          child: CustomButton(
                            child: Text(
                              "ذهاب و عودة",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: (myTripsAgendaController.isOneWay)
                                    ? AppColors.blue
                                    : Colors.white,
                              ),
                            ),
                            onTap: () {
                              myTripsAgendaController.setTripDirection(
                                  oneWay: false);
                            },
                            btnColor: (myTripsAgendaController.isOneWay)
                                ? Colors.white
                                : AppColors.blue,
                            addShadow: false,
                            borderRadius: 20.0.r,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                // Rounded Corners White Container
                Container(
                  width: 376.0.w,
                  // height: 660.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0.r),
                    color: Colors.white,
                  ),
                  child: GetBuilder<MyTripsAgendaController>(
                    init: myTripsAgendaController,
                    builder: (myTripsAgendaController) {
                      if (myTripsAgendaController.getCitiesDataStatus ==
                              GetCitiesDataStatus.initial ||
                          myTripsAgendaController.getCitiesDataStatus ==
                              GetCitiesDataStatus.loading) {
                        return Center(
                            child: LoadingWidget(
                          color: AppColors.blue,
                          size: 50.0,
                        ));
                      } else if (myTripsAgendaController.getCitiesDataStatus ==
                          GetCitiesDataStatus.error) {
                        return ErrorPanel(
                          failure: myTripsAgendaController.getCitiesDataFailure,
                          onTryAgain: () async {
                            await myTripsAgendaController.getAirportsData();
                          },
                        );
                      } else {
                        return Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // Departure + Arrival Place
                              Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                              Stack(
                                children: [
                                  PositionedDirectional(
                                    top: 50.0.h,
                                    start: 310.0.w,
                                    child: Image.asset(
                                      "assets/images/arrow.png",
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 340.0.w,
                                        height: 50.0.h,
                                        child: RegularTripsDropdownfield(
                                          hintText: "",
                                          onChanged: (String? value) {
                                            myTripsAgendaController
                                                    .selectedDeparturePlace =
                                                value!;
                                          },
                                          dropDownList: myTripsAgendaController
                                              .departureCitiesDropdownItems,
                                          title: "من",
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 26.0.h)),
                                      // Arrival Place
                                      SizedBox(
                                        width: 340.0.w,
                                        height: 50.0.h,
                                        child: RegularTripsDropdownfield(
                                          hintText: "",
                                          onChanged: (String? value) {
                                            myTripsAgendaController
                                                .selectedArrivalPlace = value!;
                                          },
                                          dropDownList: myTripsAgendaController
                                              .arrivalCitiesDropdownItems,
                                          title: "إلى",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Departure - Arrival Date Row
                              Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                              GetBuilder<MyTripsAgendaController>(
                                  init: myTripsAgendaController,
                                  builder: (myTripsAgendaController) {
                                    if (myTripsAgendaController.isOneWay ==
                                        false) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: 163.0.w,
                                            child: RegularTripsDatepicker(
                                              controller:
                                                  myTripsAgendaController
                                                      .departureDateController,
                                              title: "تاريخ الذهاب",
                                              onDateSelected: (DateTime value) {
                                                myTripsAgendaController
                                                    .update();
                                              },
                                              validator: (value) {
                                                if (myTripsAgendaController
                                                    .departureDateController
                                                    .text
                                                    .isEmpty) {
                                                  print("validate");
                                                  return 'تاريخ الذهاب مطلوب';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 163.0.w,
                                            child: RegularTripsDatepicker(
                                              controller:
                                                  myTripsAgendaController
                                                      .returnDateController,
                                              title: "تاريخ العودة",
                                              validator: (value) {
                                                if (myTripsAgendaController
                                                    .returnDateController
                                                    .text
                                                    .isEmpty) {
                                                  return "تاريخ العودة مطلوب";
                                                }
                                                return null;
                                              },
                                              onDateSelected: (DateTime value) {
                                                myTripsAgendaController
                                                    .update();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  right: 20.0.w)),
                                          SizedBox(
                                            width: 200.0.w,
                                            child: RegularTripsDatepicker(
                                              controller:
                                                  myTripsAgendaController
                                                      .departureDateController,
                                              validator: (value) {
                                                print('validated');
                                                if (myTripsAgendaController
                                                    .departureDateController
                                                    .text
                                                    .isEmpty) {
                                                  print("validate");
                                                  return 'تاريخ الرحلة مطلوب';
                                                }
                                                return null;
                                              },
                                              title: "تاريخ الرحلة",
                                              onDateSelected: (DateTime value) {
                                                myTripsAgendaController
                                                    .update();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                              // Adults - Children - Babies Number Row
                              Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                              // Passengers Count Text Row
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "عدد الركاب",
                                      style: context.textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 20.0.h)),
                              // Passengers Count Fields
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Adults
                                    Expanded(
                                      child: SizedBox(
                                        height: 70.0.h,
                                        child: RegularTripsDropdownfield(
                                          hintText: "",
                                          title: "البالغين",
                                          dropDownList: List.generate(
                                            10,
                                            (index) => DropdownMenuItem<String>(
                                              value: index.toString(),
                                              child: Text(
                                                index.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          value: myTripsAgendaController
                                                  .adultsCountController
                                                  .text
                                                  .isEmpty
                                              ? "0"
                                              : myTripsAgendaController
                                                  .adultsCountController.text,
                                          onChanged: (String? value) {
                                            myTripsAgendaController
                                                .adultsCountController
                                                .text = value ?? "0";
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0.w),
                                    // Children
                                    Expanded(
                                      child: SizedBox(
                                        height: 70.0.h,
                                        child: RegularTripsDropdownfield(
                                          hintText: "",
                                          title: "الأطفال",
                                          dropDownList: List.generate(
                                            10,
                                            (index) => DropdownMenuItem<String>(
                                              value: index.toString(),
                                              child: Text(
                                                index.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          value: myTripsAgendaController
                                                  .childrenCountController
                                                  .text
                                                  .isEmpty
                                              ? "0"
                                              : myTripsAgendaController
                                                  .childrenCountController.text,
                                          onChanged: (String? value) {
                                            myTripsAgendaController
                                                .childrenCountController
                                                .text = value ?? "0";
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0.w),
                                    // Babies
                                    Expanded(
                                      child: SizedBox(
                                        height: 70.0.h,
                                        child: RegularTripsDropdownfield(
                                          hintText: "",
                                          title: "الرضع",
                                          dropDownList: List.generate(
                                            10,
                                            (index) => DropdownMenuItem<String>(
                                              value: index.toString(),
                                              child: Text(
                                                index.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          value: myTripsAgendaController
                                                  .babiesCountController
                                                  .text
                                                  .isEmpty
                                              ? "0"
                                              : myTripsAgendaController
                                                  .babiesCountController.text,
                                          onChanged: (String? value) {
                                            myTripsAgendaController
                                                .babiesCountController
                                                .text = value ?? "0";
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Nationality Row
                              Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 340.0.w,
                                    height: 50.0.h,
                                    child: RegularTripsDropdownfield(
                                      hintText: "",
                                      onChanged: (String? value) {
                                        myTripsAgendaController
                                            .selectedNationality = value!;
                                      },
                                      dropDownList: myTripsAgendaController
                                          .nationalityDropdownItems,
                                      title: "الجنسية",
                                    ),
                                  ),
                                ],
                              ),
                              // Currency Row
                              Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 340.0.w,
                                    height: 50.0.h,
                                    child: RegularTripsDropdownfield(
                                      hintText: "",
                                      onChanged: (String? value) {
                                        myTripsAgendaController
                                            .selectedCurrency = value!;
                                      },
                                      dropDownList: myTripsAgendaController
                                          .currencyDropdownItems,
                                      title: "العملة",
                                    ),
                                  ),
                                ],
                              ),
                              // Trip Level Row
                              Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 340.0.w,
                                    height: 50.0.h,
                                    child: RegularTripsDropdownfield(
                                      hintText: "",
                                      onChanged: (String? value) {
                                        myTripsAgendaController
                                            .selectedTripLevel = value!;
                                      },
                                      dropDownList: myTripsAgendaController
                                          .tripLevelDropdownItems,
                                      title: "الدرجة",
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 26.0.h)),
                              // Search Button
                              SizedBox(
                                width: 222.0.w,
                                child: CustomButton(
                                  onTap: () async {
                                    if (myTripsAgendaController
                                            .selectedArrivalPlace ==
                                        myTripsAgendaController
                                            .selectedDeparturePlace) {
                                      toastification.show(
                                        context: context,
                                        title: const Text("خطأ تشابه الوجهات"),
                                        description: const Text(
                                            "يرجى اختيار وجهات الرحلة بشكل دقيق."),
                                        type: ToastificationType.info,
                                        style: ToastificationStyle.fillColored,
                                        autoCloseDuration:
                                            const Duration(seconds: 8),
                                      );
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        try {
                                          if ((int.tryParse(
                                                      myTripsAgendaController
                                                          .adultsCountController
                                                          .text)! +
                                                  int.tryParse(
                                                      myTripsAgendaController
                                                          .childrenCountController
                                                          .text)! +
                                                  int.tryParse(
                                                      myTripsAgendaController
                                                          .babiesCountController
                                                          .text)!) >
                                              9) {
                                            toastification.show(
                                              context: context,
                                              title:
                                                  const Text("خطأ تعدد الركاب"),
                                              description: const Text(
                                                  "يجب أن يكون العدد أقل من 10"),
                                              type: ToastificationType.info,
                                              style: ToastificationStyle
                                                  .fillColored,
                                            );
                                          } else {
                                            myTripsAgendaController.parseText();
                                            await myTripsAgendaController
                                                .searchRegularTrips();
                                          }
                                        } catch (e) {
                                          myTripsAgendaController.parseText();
                                          await myTripsAgendaController
                                              .searchRegularTrips();
                                        }
                                      }
                                    }
                                  },
                                  btnColor: AppColors.blue,
                                  addShadow: false,
                                  borderRadius: 15.0.r,
                                  padding: 10.0.r,
                                  child: GetBuilder<MyTripsAgendaController>(
                                    init: myTripsAgendaController,
                                    builder: (myTripsAgendaController) {
                                      if (myTripsAgendaController
                                              .searchTripsDataStatus ==
                                          SearchTripsDataStatus.loading) {
                                        return LoadingWidget(
                                          size: 25.0,
                                          color: Colors.white,
                                        );
                                      } else if (myTripsAgendaController
                                              .searchTripsDataStatus ==
                                          SearchTripsDataStatus.error) {
                                        return ErrorBanner(
                                          failure: myTripsAgendaController
                                              .searchTripsDataFailure,
                                          tryAgain: () async {
                                            await myTripsAgendaController
                                                .searchRegularTrips();
                                          },
                                        );
                                      } else {
                                        return Text(
                                          "بحث",
                                          style: context.textTheme.titleMedium!
                                              .copyWith(
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
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
