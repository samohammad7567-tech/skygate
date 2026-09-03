import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/error_panel.dart';
import 'package:skygate/tourism/global_widgets/loading_widget.dart';
import 'package:skygate/tourism/modules/language/language_controller.dart';
import 'package:skygate/tourism/modules/notifications/views/widgets/notification_card.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  final notificationsController = Get.find<NotificationsController>();
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      init: notificationsController,
      builder: (notificationsController) {
        if ((notificationsController.getNotificationsDataStatus ==
                GetNotificationsDataStatus.loading) ||
            (notificationsController.getNotificationsDataStatus ==
                GetNotificationsDataStatus.initial)) {
          return LoadingWidget(
            color: AppColors.blue,
            size: 35.0,
          );
        } else if (notificationsController.getNotificationsDataStatus ==
            GetNotificationsDataStatus.error) {
          return ErrorPanel(
            failure: notificationsController.getNotificationsDataFailure,
            onTryAgain: () async {
              await notificationsController.getNotifications();
            },
          );
        } else {
          if (notificationsController.notificationsList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/no-notifications.png",
                  width: 200.0.w,
                ),
                Padding(padding: EdgeInsets.only(bottom: 30.0.h)),
                Text(
                  tr("no-notifications"),
                  style: context.textTheme.headlineMedium,
                ),
              ],
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(20.0.r), // Adds padding to left and right
              physics:
                  const ClampingScrollPhysics(), // Prevents unbounded scrolling
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 200.0.w,
                  height: 150.0.h,
                  child: NotificationCard(
                    body: notificationsController
                        .notificationsList[index].content,
                    createDate: notificationsController
                        .notificationsList[index].created_at,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(padding: EdgeInsets.only(bottom: 35.0.h));
              },
              itemCount: notificationsController.notificationsList.length,
            );
          }
        }
      },
    );
  }
}
