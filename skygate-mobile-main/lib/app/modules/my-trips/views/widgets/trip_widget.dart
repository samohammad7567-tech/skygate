import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/core/utils/helpers/launcher_helper.dart';
import 'package:sky_gate/app/global_widgets/custom_button.dart';
import 'package:sky_gate/app/global_widgets/custom_white_outlined_button.dart';
import 'package:sky_gate/app/modules/my-trips/controllers/my_trips_controller.dart';
import 'package:sky_gate/app/modules/my-trips/models/condition_model.dart';
import 'package:sky_gate/app/routes/app_pages.dart';

import '../../../../core/utils/constants/constants.dart';

class TripWidget extends StatelessWidget {
  TripWidget(
      {super.key,
      this.departureDate,
      this.departureCity,
      this.arrivalCity,
      this.file,
      this.index,
      this.ticketID,
      this.conditions,
      this.conditions_accepted,
      this.filesList});

  final String? departureDate;
  final String? departureCity;
  final String? arrivalCity;
  final String? file;
  final String? ticketID;
  final ConditionModel? conditions;
  final String? conditions_accepted;
  final int? index;
  final List<String>? filesList;

  final myTripsController = Get.find<MyTripsController>();

  void _showFilesDialog(BuildContext context) {
    if (filesList == null || filesList!.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "لا توجد ملفات متاحة",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "اختر ملف للتحميل",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filesList!.length,
              separatorBuilder: (context, index) => Divider(height: 1.h),
              itemBuilder: (context, index) {
                String fileName = filesList![index].split('/').last;
                return ListTile(
                  leading: Icon(
                    Icons.insert_drive_file,
                    color: AppColors.blue,
                    size: 30,
                  ),
                  title: Text(
                    fileName,
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    "الملف ${index + 1}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: Icon(
                    Icons.download,
                    color: AppColors.blue,
                    size: 24,
                  ),
                  onTap: () {
                    print(filesList);
                    LauncherHelper.downloadFile(
                        fileURL: NetworkRoutesControl.imageUrl +
                            jsonDecode(filesList![index])['download_link']);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إلغاء",
                style: TextStyle(color: AppColors.blue, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0.r),
            color: Colors.white,
            border: Border.all(
              color: AppColors.greyMedium,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تذكرة سفر',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF22509E),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      height: 1.57,
                    ),
                  ),
                  Text(
                    '${departureDate!.substring(0, 10)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      height: 1.57,
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${departureCity} - ${arrivalCity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF22509E),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      height: 1.10,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reminder Button
                  SizedBox(
                    width: 150.0.w,
                    child: CustomButton(
                      onTap: () {
                        Get.toNamed(Routes.TICKET_REMINDER);
                      },
                      btnColor: AppColors.blue,
                      addShadow: false,
                      borderRadius: 30.0.r,
                      padding: 10.0.r,
                      child: Text(
                        "تذكير",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  // Details Button
                  SizedBox(
                    width: 150.0.w,
                    child: CustomWhiteOutlinedButton(
                      onTap: () async {
                        myTripsController.onDetailsBtnClicked(index: index);
                      },
                      addShadow: false,
                      borderColor: AppColors.blue,
                      child: Text(
                        "تفاصيل",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: AppColors.blue,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 23.0.h)),
        // Content After Clicking Details Button
        GetBuilder<MyTripsController>(
          init: myTripsController,
          builder: (myTripsController) {
            return Visibility(
              visible: (myTripsController.clickedCardIndex == index),
              child: Column(
                children: [
                  // Print Ticket PDF File + Ticket Conditions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150.0.w,
                        height: 80.0.h,
                        child: CustomButton(
                          onTap: () {
                            _showFilesDialog(context);
                          },
                          btnColor: AppColors.blue,
                          addShadow: false,
                          borderRadius: 30.0.r,
                          padding: 15.0.r,
                          child: Text(
                            textAlign: TextAlign.center,
                            "تحميل \nالتذكرة PDF",
                            style: context.textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 30.0.h)),
                      SizedBox(
                        width: 150.0.w,
                        height: 80.0.h,
                        child: CustomButton(
                          onTap: () {
                            myTripsController.conditions = conditions!;
                            myTripsController.conditions_accepted =
                                conditions_accepted!;
                            myTripsController.ticketID = ticketID!;
                            Get.toNamed(Routes.TICKET_CONDITIONS);
                          },
                          btnColor: AppColors.blue,
                          addShadow: false,
                          borderRadius: 30.0.r,
                          padding: 15.0.r,
                          child: Text(
                            textAlign: TextAlign.center,
                            "شروط \nالتذكرة",
                            style: context.textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                  // Airport Taxi + ADD Travel Notes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150.0.w,
                        child: CustomButton(
                          onTap: () {
                            Get.toNamed(Routes.AIRPORT_TAXI);
                          },
                          btnColor: AppColors.blue,
                          addShadow: false,
                          borderRadius: 30.0.r,
                          padding: 15.0.r,
                          child: Text(
                            textAlign: TextAlign.center,
                            "طلب تاكسي المطار",
                            style: context.textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 30.0.h)),
                      SizedBox(
                        width: 150.0.w,
                        child: CustomButton(
                          onTap: () {
                            myTripsController.ticketID = ticketID!;
                            Get.toNamed(Routes.ADD_TRIP_NOTES);
                          },
                          btnColor: AppColors.blue,
                          addShadow: false,
                          borderRadius: 30.0.r,
                          padding: 15.0.r,
                          child: Text(
                            textAlign: TextAlign.center,
                            "إضافة ملاحظات السفر",
                            style: context.textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
      ],
    );
  }
}
