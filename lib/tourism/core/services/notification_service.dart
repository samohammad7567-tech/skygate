import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init({required Function(String? payload) onSelectedNot}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void requestIOSPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
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
    threadIdentifier: "",
  );

  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );

  Future<void> showNotifications({
    String? notificationTitle,
    String? notificationBody,
    int? id,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id!,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
}
