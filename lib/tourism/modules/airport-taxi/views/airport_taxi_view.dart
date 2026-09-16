import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/global_widgets/custom_dropdown_field.dart';
import 'package:skygate/tourism/global_widgets/date_picker_form_field.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/global_widgets/time_picker_form_field.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/failures/field_failure/required_field_failure.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_form_field.dart';
import '../controllers/airport_taxi_controller.dart';

class AirportTaxiView extends GetView<AirportTaxiController> {
  AirportTaxiView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final airportTaxiController = Get.find<AirportTaxiController>();
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
                  "تكسي المطار",
                  style: context.textTheme.displayLarge!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 40.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 60.0.h)),
                GetBuilder<AirportTaxiController>(
                  init: airportTaxiController,
                  builder: (airportTaxiController) {
                    if (airportTaxiController
                                .getAirportTaxiRequestsDataStatus ==
                            GetAirportTaxiRequestsDataStatus.initial ||
                        airportTaxiController
                                .getAirportTaxiRequestsDataStatus ==
                            GetAirportTaxiRequestsDataStatus.loading) {
                      return Column(
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 300.0.h)),
                          LoadingWidget(color: AppColors.blue, size: 40.0),
                        ],
                      );
                    } else if (airportTaxiController
                            .getAirportTaxiRequestsDataStatus ==
                        GetAirportTaxiRequestsDataStatus.error) {
                      return Column(
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 300.0.h)),
                          ErrorPanel(
                            failure: airportTaxiController
                                .getAirportTaxiRequestsDataFailure,
                            onTryAgain: () async {
                              await airportTaxiController
                                  .getAirportTaxiRequests();
                            },
                          ),
                        ],
                      );
                    } else {
                      if (airportTaxiController
                          .airportTaxiRequestsList
                          .isEmpty) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomDropdownField(
                                hintText: "المطار",
                                dropDownList:
                                    airportTaxiController.airportsDropdownItems,
                                onChanged: (String? value) {
                                  airportTaxiController.selectedAirport = value;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              CustomDropdownField(
                                hintText: "اتجاه المسير",
                                dropDownList: airportTaxiController
                                    .tripDirectionsDropdownItems,
                                onChanged: (String? value) {
                                  airportTaxiController.selectedTripDirection =
                                      value;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              CustomFormField(
                                hintText: "موقع المنزل",
                                isPassword: false,
                                maxLength: 30,
                                readOnly: true,
                                onTap: () {
                                  Get.toNamed(Routes.MAP_VIEW);
                                },
                                controller: airportTaxiController
                                    .homeLocationController,
                                autoValidate: false,
                                validator: (String value) {
                                  if (value == "") {
                                    return RequiredFieldFailure();
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              CustomFormField(
                                hintText: "عنوان المنزل بالتفصيل",
                                isPassword: false,
                                maxLength: 40,
                                maxLines: 1,
                                controller:
                                    airportTaxiController.homeAddressController,
                                autoValidate: false,
                                validator: (String value) {
                                  if (value == "") {
                                    return RequiredFieldFailure();
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              DatePickerFormField(
                                hintText: "التاريخ",
                                controller:
                                    airportTaxiController.dateController,
                                onDateSelected: (DateTime value) {
                                  airportTaxiController.update();
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              TimePickerFormField(
                                controller: airportTaxiController
                                    .planeDepartureTimeController,
                                hintText: "توقيت إقلاع الطائرة",
                                validator: (String? value) {
                                  if (value == "") {
                                    return "يرجى إدخال توقيت الرحلة.";
                                  }
                                  return null;
                                },
                                onTimePick: (TimeOfDay value) {
                                  airportTaxiController.update();
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              CustomFormField(
                                hintText: "عدد الركاب",
                                isPassword: false,
                                maxLength: 30,
                                controller: airportTaxiController
                                    .passengersNumberController,
                                autoValidate: false,
                                validator: (String value) {
                                  if (value == "") {
                                    return RequiredFieldFailure();
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                              SizedBox(
                                width: 244.0.w,
                                child: CustomButton(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await airportTaxiController
                                          .sendTaxiRequest(context: context);
                                    }
                                  },
                                  borderRadius: 30.0,
                                  btnColor: AppColors.blue,
                                  addShadow: false,
                                  child: GetBuilder<AirportTaxiController>(
                                    init: airportTaxiController,
                                    builder: (airportTaxiController) {
                                      if (airportTaxiController
                                          .airportTaxiRequestLoading) {
                                        return LoadingWidget(
                                          color: AppColors.blue,
                                          size: 20.0,
                                        );
                                      } else {
                                        return Text(
                                          "طلب تكسي المطار",
                                          style: context.textTheme.titleSmall!
                                              .copyWith(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Padding(padding: EdgeInsets.only(bottom: 250.0.h)),
                            Text(
                              "إن طلبك قيد المعالجة، سيتم تنفيذ الطلب في أقصى سرعة ممكنة. نشكر تعاونكم و تفهمكم.",
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        );
                      }
                    }
                  },
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
