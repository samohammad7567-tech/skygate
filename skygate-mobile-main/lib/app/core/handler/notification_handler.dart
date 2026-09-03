import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../data/model/push_notification/recived_push_notification.dart';
import '../../data/model/push_notification/selected_push_notification.dart';
import '../../data/service/repository/push_notification_repository.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

Future<void> _showNotification(
    String title, String body, String? payload) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          PushNotificationRepository.channelId, PushNotificationRepository.channelName,
          channelDescription:
              'Notification with high priority will be received with this channel',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);
}

class NotificationHandler {
  void listenForReceivedNotification() {
    PushNotificationRepository repository =
        Get.find<PushNotificationRepository>();
    repository.receivedNotificationStreamController.stream
        .listen((ReceivedPushNotification event) {
      _showNotification(event.body, event.title, null);
    });
  }

  void listenForSelectedNotification() {
    PushNotificationRepository repository =
        Get.find<PushNotificationRepository>();
    repository.selectedNotificationStreamController.stream
        .listen((SelectedPushNotification event) {
      log("selected notification with payload: ${event.payload}");
    });
  }
}
