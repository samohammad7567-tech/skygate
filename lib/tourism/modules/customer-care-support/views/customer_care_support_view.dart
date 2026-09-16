import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/gesture_page.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import '../controllers/customer_care_support_controller.dart';
import 'package:path/path.dart' as path;

class CustomerCareSupportView extends GetView<CustomerCareSupportController> {
  CustomerCareSupportView({super.key});

  final customCareSupportController = Get.find<CustomerCareSupportController>();

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
          child: Scrollbar(
            controller: customCareSupportController.scrollController,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                Text(
                  "رعاية الزبائن",
                  style: context.textTheme.displayLarge!.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                GetBuilder<CustomerCareSupportController>(
                  init: customCareSupportController,
                  builder: (customCareSupportController) {
                    if (customCareSupportController.readMessagesStatus ==
                            ReadMessagesStatus.loading ||
                        customCareSupportController.readMessagesStatus ==
                            ReadMessagesStatus.initial) {
                      return Expanded(
                        child: LoadingWidget(color: AppColors.blue, size: 50.0),
                      );
                    } else if (customCareSupportController.readMessagesStatus ==
                        ReadMessagesStatus.error) {
                      return ErrorPanel(
                        failure:
                            customCareSupportController.readMessagesFailure,
                        onTryAgain: () async {
                          await customCareSupportController.readMessages();
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: 655.0.h,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              controller:
                                  customCareSupportController.scrollController,
                              itemCount:
                                  customCareSupportController.messages.length,
                              itemBuilder: (context, index) {
                                return customCareSupportController
                                    .messages[index];
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<CustomerCareSupportController>(
          init: customCareSupportController,
          builder: (_) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0.w,
                  vertical: 8.0.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GetBuilder<CustomerCareSupportController>(
                      init: customCareSupportController,
                      builder: (salesSupportController) {
                        if (salesSupportController.haveAttach == true) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0.w,
                              vertical: 8.0.w,
                            ),
                            height: 40.0.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Text(
                              path.basename(salesSupportController.attach.path),
                              style: context.textTheme.titleSmall,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.0.h)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                customCareSupportController.messageController,
                            decoration: InputDecoration(
                              hintText: 'اسأل ما تشاء...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0.r),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0.w,
                              ),
                            ),
                            onSubmitted: (_) =>
                                customCareSupportController.sendMessage(),
                          ),
                        ),
                        SizedBox(width: 8.0.w),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(allowMultiple: false);
                              if (result != null) {
                                customCareSupportController.haveAttach = true;
                                customCareSupportController.attach = File(
                                  result.files.single.path!,
                                );
                                customCareSupportController.update();
                              } else {
                                log("User canceled the picker");
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.0.w),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: customCareSupportController.sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
