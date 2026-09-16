import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/services/notification_service.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:skygate/tourism/core/utils/failures/failures.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/notifications/models/notification_model.dart';
import 'package:skygate/tourism/modules/notifications/repository/notifications_repository.dart';
import 'package:flutter/foundation.dart';

enum GetNotificationsDataStatus { initial, loading, error, success }

enum DeleteNotificationStatus { initial, loading, error, success }

int notificationID = 0;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.notification!.body}");

  notificationID++;

  NotificationService().showNotifications(
    notificationTitle: message.notification!.title,
    notificationBody: message.notification!.body,
    id: notificationID,
  );
}

class NotificationsController extends GetxController {
  GetNotificationsDataStatus getNotificationsDataStatus =
      GetNotificationsDataStatus.initial;
  Failure getNotificationsDataFailure = const ServerFailure();

  DeleteNotificationStatus deleteNotificationStatus =
      DeleteNotificationStatus.initial;
  Failure deleteNotificationFailure = const ServerFailure();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final logger = SimpleLogger();

  List<NotificationModel> notificationsList = [];
  NotificationsRepository notificationsRepository = NotificationsRepository();

  @override
  void onInit() async {
    super.onInit();
    tz.initializeTimeZones();
    await getNotifications();
  }



  Future<void> getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      log("Device FCM Token unavailable");
      return;
    }
    SharedClass.fcmToken = fcmToken;
    log("Device FCM Token :  $fcmToken");
  }

  Future<void> flutterLocalNotificationsInitiate() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationService().init(
      onSelectedNot: (String? payload) {
        logger.info("notification payload $payload");
      },
    );

    NotificationService().requestIOSPermissions(
      flutterLocalNotificationsPlugin,
    );

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
    logger.info('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.body}');

      notificationID++;

      NotificationService().showNotifications(
        notificationTitle: message.notification!.title,
        notificationBody: message.notification!.body,
        id: notificationID,
      );

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification!.body}',
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> getNotifications() async {
    getNotificationsDataStatus = GetNotificationsDataStatus.loading;
    update();

    (await notificationsRepository.getUserNotifications()).fold(
      (left) {
        getNotificationsDataFailure = left;
        getNotificationsDataStatus = GetNotificationsDataStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          getNotificationsDataStatus = GetNotificationsDataStatus.success;
          update();
          notificationsList = right.data!;
        } else {
          notificationsList = [];
          getNotificationsDataStatus = GetNotificationsDataStatus.success;
          update();
        }
      },
    );
  }
}
