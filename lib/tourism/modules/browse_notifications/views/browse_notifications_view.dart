import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/modules/notifications/controllers/notifications_controller.dart';
import 'package:skygate/tourism/modules/notifications/views/notifications_view.dart';

import '../controllers/browse_notifications_controller.dart';

class BrowseNotificationsView extends GetView<BrowseNotificationsController> {

  final notificationsController = Get.find<NotificationsController>();
  final browseNotificationsController = Get.find<BrowseNotificationsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        leading:TextButton(
          onPressed: () async {

          },
          child: Icon(Icons.refresh),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await browseNotificationsController.logoutUser();
              },
              child: Text(
                tr("logout"),
                style: context.textTheme.headlineSmall!.copyWith(
                  color: AppColors.blue,
                ),
              ),
          ),
        ],
        title: Text(
          tr("notifications"),
          style: context.textTheme.headlineLarge!.copyWith(
            color: AppColors.blue[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: 1 * 1.sw,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home-scaffold-bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: NotificationsView(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
