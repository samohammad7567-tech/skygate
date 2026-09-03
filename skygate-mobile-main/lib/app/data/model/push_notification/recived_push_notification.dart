import 'package:firebase_messaging/firebase_messaging.dart';

class ReceivedPushNotification {

  String title, body;

  ReceivedPushNotification({required this.title, required this.body});

  factory ReceivedPushNotification.fromRemoteNotification(
      RemoteNotification remoteNotification){
    return ReceivedPushNotification(title: remoteNotification.title ?? '',
        body: remoteNotification.body ?? '');
  }

}