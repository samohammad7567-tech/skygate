import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_button.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/controllers/my_bookings_requests_controller.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/views/widgets/passport_option_card.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/views/widgets/scanned_passport_card.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/views/widgets/file_passport_card.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/views/widgets/local_file_card.dart';
import 'package:skygate/tourism/routes/app_pages.dart';

class AddPassportsView extends StatelessWidget {
  const AddPassportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            Text(
              "أضف جوازات السفر",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
            GetBuilder<MyBookingsRequestsController>(
              builder: (controller) {
                final hasPassports = controller.passports.isNotEmpty;
                final hasFiles = controller.passportFiles.isNotEmpty;
                final hasBackendFilePassports =
                    hasPassports &&
                    controller.passports.every(
                      (p) => p.fileUrl.isNotEmpty && p.passportNumber.isEmpty,
                    );
                final hasScannedPassports =
                    hasPassports && !hasBackendFilePassports;

                return (!hasPassports && !hasFiles)
                    ? Column(
                        children: [
                          PassportOptionCard(
                            icon: Icons.camera_alt,
                            text: "امسح جواز السفر بالكاميرا لإضافة الجواز",
                            onTap: () {
                              controller.clearPassportFiles();
                              Get.toNamed(Routes.PASSPORT_SCANNER_VIEW);
                            },
                          ),
                          PassportOptionCard(
                            icon: Icons.attach_file,
                            text: "أرفق صور أو ملفات PDF لجوازات السفر",
                            onTap: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                    allowMultiple: true,
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'jpeg',
                                      'png',
                                      'pdf',
                                    ],
                                  );

                              if (result != null && result.files.isNotEmpty) {
                                final files = result.files
                                    .where((f) => f.path != null)
                                    .map((f) => File(f.path!))
                                    .toList();

                                controller.clearPassports();
                                controller.setPassportFiles(files);
                              }
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          if (hasScannedPassports && !hasFiles)
                            CustomButton(
                              onTap: () {
                                if (controller.passportFiles.isNotEmpty) {
                                  Get.snackbar(
                                    "تنبيه",
                                    "لا يمكنك إضافة جوازات ممسوحة بالكاميرا أثناء وجود ملفات مرفقة. يرجى إزالة الملفات المرفقة أولاً.",
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 4),
                                  );
                                  return;
                                }
                                Get.toNamed(Routes.PASSPORT_SCANNER_VIEW);
                              },
                              btnColor: Colors.white,
                              addShadow: false,
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0.r),
                                  border: Border.all(color: AppColors.blue),
                                ),
                                child: const Text('أضف جواز آخر'),
                              ),
                            ),
                          if (hasBackendFilePassports || hasFiles)
                            CustomButton(
                              onTap: () async {
                                if (hasScannedPassports) {
                                  Get.snackbar(
                                    "تنبيه",
                                    "لا يمكنك إرفاق ملفات أثناء وجود جوازات ممسوحة بالكاميرا. يرجى إزالة الجوازات الممسوحة أولاً.",
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 4),
                                  );
                                  return;
                                }

                                final result = await FilePicker.platform
                                    .pickFiles(
                                      allowMultiple: true,
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpg',
                                        'jpeg',
                                        'png',
                                        'pdf',
                                      ],
                                    );

                                if (result != null && result.files.isNotEmpty) {
                                  final files = result.files
                                      .where((f) => f.path != null)
                                      .map((f) => File(f.path!))
                                      .toList();
                                  controller.addPassportFiles(files);
                                }
                              },
                              btnColor: Colors.white,
                              addShadow: false,
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0.r),
                                  border: Border.all(color: AppColors.blue),
                                ),
                                child: const Text(
                                  'أرفق صور / ملفات PDF للجوازات',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                          SizedBox(
                            width: double.infinity,
                            child: hasScannedPassports
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.passports.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                          return const SizedBox(height: 20);
                                        },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return ScannedPassportCard(
                                            passport:
                                                controller.passports[index],
                                            onRemove: () async {
                                              await controller.removePassport(
                                                index,
                                              );
                                            },
                                          );
                                        },
                                  )
                                : Column(
                                    children: [
                                      if (hasBackendFilePassports)
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              controller.passports.length,
                                          separatorBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return const SizedBox(
                                                  height: 20,
                                                );
                                              },
                                          itemBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return FilePassportCard(
                                                  passport: controller
                                                      .passports[index],
                                                  onRemove: () async {
                                                    await controller
                                                        .removePassport(index);
                                                  },
                                                );
                                              },
                                        ),
                                      if (hasFiles)
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              controller.passportFiles.length,
                                          separatorBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return const SizedBox(
                                                  height: 20,
                                                );
                                              },
                                          itemBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return LocalFileCard(
                                                  file: controller
                                                      .passportFiles[index],
                                                  onRemove: () {
                                                    controller
                                                        .removePassportFile(
                                                          index,
                                                        );
                                                  },
                                                );
                                              },
                                        ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 20.0.h),
                          GetBuilder<MyBookingsRequestsController>(
                            builder: (controller) {
                              return CustomButton(
                                onTap: () async {
                                  if (controller.addPassportsStatus ==
                                      AddPassportsStatus.loading) {
                                    return; // Prevent multiple taps while loading
                                  }
                                  final hasScannedPassports =
                                      controller.passports.isNotEmpty &&
                                      !controller.passports.every(
                                        (p) =>
                                            p.fileUrl.isNotEmpty &&
                                            p.passportNumber.isEmpty,
                                      );
                                  if (controller.passports.isEmpty &&
                                      controller.passportFiles.isEmpty) {
                                    Get.snackbar(
                                      "تحذير",
                                      "يرجى إضافة جواز سفر واحد على الأقل أو إرفاق ملفات الجوازات",
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }
                                  if (hasScannedPassports &&
                                      controller.passportFiles.isNotEmpty) {
                                    Get.snackbar(
                                      "خطأ",
                                      "لا يمكنك استخدام المسح بالكاميرا وإرفاق الملفات في نفس الوقت. يرجى اختيار طريقة واحدة فقط.",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  await controller.addPassportsToBookingRequest(
                                    bookingRequestId: controller
                                        .selectedBookingRequest
                                        ?.id
                                        .toString(),
                                  );

                                  if (controller.addPassportsStatus ==
                                      AddPassportsStatus.success) {
                                    controller.clearPassportFiles();

                                    Get.snackbar(
                                      "نجح",
                                      "تم إضافة جوازات السفر بنجاح",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                    Get.offNamed(Routes.CHOOSE_PAYMENT_METHOD);
                                  } else if (controller.addPassportsStatus ==
                                      AddPassportsStatus.error) {
                                    Get.snackbar(
                                      "خطأ",
                                      "حدث خطأ في إضافة جوازات السفر. يرجى المحاولة مرة أخرى.",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                btnColor:
                                    controller.addPassportsStatus ==
                                        AddPassportsStatus.loading
                                    ? Colors.grey
                                    : AppColors.blue,
                                addShadow: false,
                                child:
                                    controller.addPassportsStatus ==
                                        AddPassportsStatus.loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "التالي",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                              );
                            },
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
