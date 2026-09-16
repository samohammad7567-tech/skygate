import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/handler/notification_handler.dart';
import '../../model/push_notification/recived_push_notification.dart';
import '../../model/push_notification/selected_push_notification.dart';

class PushNotificationRepository {
  static const String channelName = 'Sound Channel';
  static const String channelId = 'sound_channel';
  PushNotificationRepository() {
    init();
  }

  StreamController<SelectedPushNotification>
  selectedNotificationStreamController =
      StreamController<SelectedPushNotification>();

  StreamController<ReceivedPushNotification>
  receivedNotificationStreamController =
      StreamController<ReceivedPushNotification>();

  Future<void> init() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationStreamController.add(
        SelectedPushNotification.fromNotificationDetails(
          notificationAppLaunchDetails!,
        ),
      );
    }

    await flutterLocalNotificationsPlugin.initialize(
      _getLocalNotificationInitialization(),
      onDidReceiveNotificationResponse: (NotificationResponse? response) async {
        selectedNotificationStreamController.add(
          SelectedPushNotification(payload: response!.payload ?? ''),
        );
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse? response) async {
            selectedNotificationStreamController.add(
              SelectedPushNotification(payload: response!.payload ?? ''),
            );
          },
    );

    _createNotificationChannel(channelId, channelName);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');

        receivedNotificationStreamController.add(
          ReceivedPushNotification.fromRemoteNotification(
            message.notification!,
          ),
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    debugPrint(
      'Firebase Token: ${await FirebaseMessaging.instance.getToken()}',
    );
  }

  InitializationSettings _getLocalNotificationInitialization() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification_default');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: <DarwinNotificationCategory>[
            DarwinNotificationCategory(
              "Skygate-Category",
              options: <DarwinNotificationCategoryOption>{
                DarwinNotificationCategoryOption.allowAnnouncement,
                DarwinNotificationCategoryOption.allowInCarPlay,
              },
            ),
          ],
        );
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    return initializationSettings;
  }

  Future<void> _createNotificationChannel(String id, String name) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
      importance: Importance.high,
      playSound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);
  }
}
