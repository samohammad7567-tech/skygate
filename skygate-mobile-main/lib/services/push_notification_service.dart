import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../app/data/model/push_notification/recived_push_notification.dart';
import 'notification_service.dart';

/// Handles a push received while the app is terminated or backgrounded.
///
/// Must stay a top level function annotated with `vm:entry-point`: Firebase
/// spawns a dedicated isolate for it, so `Firebase.initializeApp` has to run
/// again before touching any Firebase service.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message: ${message.messageId}');
}

/// Firebase Cloud Messaging.
///
/// Requests the notification permission, exposes the FCM token, and forwards
/// foreground messages on [messages]. Displaying them is delegated to
/// [NotificationService] when [showForegroundNotifications] is left on.
///
/// `Firebase.initializeApp()` must have completed before [init] is called.
class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// When true, a foreground message is also shown as a local notification.
  bool showForegroundNotifications = true;

  final StreamController<ReceivedPushNotification> _messageController =
      StreamController<ReceivedPushNotification>.broadcast();

  /// Notifications received while the app is in the foreground.
  Stream<ReceivedPushNotification> get messages => _messageController.stream;

  /// Payloads of pushes the user tapped, forwarded from [NotificationService].
  Stream<String> get selections => NotificationService.instance.selections;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  bool _initialised = false;

  /// The device FCM token, `null` when it could not be resolved.
  String? token;

  /// Sets up local notifications, requests permission, resolves the token and
  /// starts listening for messages. Safe to call more than once.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    await NotificationService.instance.init();
    await requestPermission();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    token = await refreshToken();
    log('Firebase token: $token');
  }

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus;
  }

  /// Re-reads the FCM token and caches it in [token].
  Future<String?> refreshToken() async {
    try {
      return token = await _messaging.getToken();
    } catch (e) {
      log('Could not resolve the FCM token: $e');
      return null;
    }
  }

  /// Emitted whenever Firebase rotates the token, so the backend can be
  /// updated.
  Stream<String> get tokenRefresh => _messaging.onTokenRefresh;

  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  /// The message that opened the app from a terminated state, if any.
  Future<RemoteMessage?> initialMessage() => _messaging.getInitialMessage();

  /// Messages that opened the app from the background.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    log('Foreground message: ${message.data}');
    final received =
        ReceivedPushNotification.fromRemoteNotification(notification);
    _messageController.add(received);

    if (showForegroundNotifications) {
      NotificationService.instance.show(
        title: received.title,
        body: received.body,
        payload: message.data.toString(),
      );
    }
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _messageController.close();
  }
}
