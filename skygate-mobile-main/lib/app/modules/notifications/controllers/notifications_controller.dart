import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/services/NotificationService.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:sky_gate/app/core/utils/failures/failures.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/notifications/models/notification_model.dart';
import 'package:sky_gate/app/modules/notifications/repository/notifications_repository.dart';
// import 'package:sky_gate/firebase_options.dart';

enum GetNotificationsDataStatus {initial, loading, error, success}
enum DeleteNotificationStatus {initial, loading, error, success}


int notificationID = 0;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.notification!.body}");

  notificationID++;

  NotificationService().showNotifications(
      notificationTitle: message.notification!.title,
      notificationBody: message.notification!.body,
      id: notificationID);
}

class NotificationsController extends GetxController {

  GetNotificationsDataStatus getNotificationsDataStatus = GetNotificationsDataStatus.initial;
  Failure getNotificationsDataFailure =  const ServerFailure();

  DeleteNotificationStatus deleteNotificationStatus = DeleteNotificationStatus.initial;
  Failure deleteNotificationFailure =  const ServerFailure();

//instance of FlutterLocalNotificationsPlugin
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    SharedClass.fcmToken = fcmToken!;
    log("Device FCM Token :  ${fcmToken}");
  }

  Future<void> flutterLocalNotificationsInitiate() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationService().init(onSelectedNot: (String? payload) {
      logger.info("notification payload ${payload}");
    });

    NotificationService().requestIOSPermissions(flutterLocalNotificationsPlugin);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    logger.info('User granted permission: ${settings.authorizationStatus}');


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification!.body}');

      notificationID++;

      NotificationService().showNotifications(
          notificationTitle: message.notification!.title,
          notificationBody: message.notification!.body,
          id: notificationID);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.body}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }


  Future<void> getNotifications() async {
    getNotificationsDataStatus = GetNotificationsDataStatus.loading;
    update();

    (await notificationsRepository.getUserNotifications())
        .fold((left) {
          getNotificationsDataFailure = left;
      getNotificationsDataStatus = GetNotificationsDataStatus.error;
      update();
    }, (right) async {
      if(right.code == "1") {
        getNotificationsDataStatus = GetNotificationsDataStatus.success;
        update();
        notificationsList = right.data!;
      } else {
        notificationsList = [];
        getNotificationsDataStatus = GetNotificationsDataStatus.success;
        update();
      }
    });
  }
}
