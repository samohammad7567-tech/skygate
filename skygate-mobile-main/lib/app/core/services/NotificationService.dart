import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  Future<void> init({required Function(String? payload) onSelectedNot}) async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static final iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      attachments: [],
      subtitle: "",
      threadIdentifier: "");

  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

  Future<void> showNotifications(
      {String? notificationTitle, String? notificationBody, int? id}) async {
    await flutterLocalNotificationsPlugin.show(
      id!,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
}
