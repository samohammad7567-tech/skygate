import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SelectedPushNotification {
  String payload;

  SelectedPushNotification({required this.payload});

  factory SelectedPushNotification.fromNotificationDetails(
    NotificationAppLaunchDetails notificationAppLaunchDetails,
  ) {
    String payload =
        notificationAppLaunchDetails.notificationResponse!.payload ?? '';

    return SelectedPushNotification(payload: payload);
  }
}
