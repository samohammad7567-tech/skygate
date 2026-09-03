import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Runs in a background isolate when a notification is tapped while the app is
/// terminated. It must stay a top level function annotated with
/// `vm:entry-point`, otherwise the plugin rejects it at initialisation.
///
/// The background isolate cannot reach the UI isolate streams, so the tap is
/// only logged here; the payload is replayed on
/// `NotificationService.selections` when the app starts.
@pragma('vm:entry-point')
void notificationBackgroundResponseHandler(NotificationResponse response) {
  debugPrint('background notification tap: ${response.payload}');
}

/// Local (on device) notifications.
///
/// Owns the single `FlutterLocalNotificationsPlugin` instance for the whole
/// app, creates the Android channel, and exposes taps on [selections] instead
/// of taking a callback, so any state manager can listen.
///
/// `PushNotificationService` builds on top of this service to display the
/// notifications that arrive from Firebase while the app is in the foreground.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  /// Must match the channel declared in `AndroidManifest.xml`.
  static const String channelId = 'sound_channel';
  static const String channelName = 'Sound Channel';
  static const String channelDescription =
      'Notification with high priority will be received with this channel';

  /// Small icon used for Android notifications, from `res/drawable`.
  static const String androidIcon = 'ic_notification_default';

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<String> _selectionController =
      StreamController<String>.broadcast();

  /// Payloads of notifications the user tapped, including the one that cold
  /// started the app.
  Stream<String> get selections => _selectionController.stream;

  bool _initialised = false;

  /// Initialises the plugin, creates the Android channel and replays the
  /// notification that launched the app (if any) onto [selections].
  ///
  /// Safe to call more than once.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    await plugin.initialize(
      _initializationSettings(),
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse:
          notificationBackgroundResponseHandler,
    );

    await _createAndroidChannel();
    await _replayLaunchNotification();
  }

  /// iOS only. Android permissions are requested by the push service.
  Future<bool> requestIOSPermissions() async {
    final granted = await plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return granted ?? false;
  }

  /// Displays a notification immediately.
  Future<void> show({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    await plugin.show(id, title, body, _notificationDetails, payload: payload);
  }

  Future<void> cancel(int id) => plugin.cancel(id);

  Future<void> cancelAll() => plugin.cancelAll();

  NotificationDetails get _notificationDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  InitializationSettings _initializationSettings() {
    const android = AndroidInitializationSettings(androidIcon);

    // Permissions are requested later, not during initialisation.
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: <DarwinNotificationCategory>[
        DarwinNotificationCategory(
          'Skygate-Category',
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.allowAnnouncement,
            DarwinNotificationCategoryOption.allowInCarPlay,
          },
        ),
      ],
    );

    return const InitializationSettings(android: android, iOS: ios);
  }

  Future<void> _createAndroidChannel() async {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            importance: Importance.high,
            playSound: true,
          ),
        );
  }

  Future<void> _replayLaunchNotification() async {
    if (!kIsWeb && Platform.isLinux) return;

    final details = await plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      _selectionController.add(details?.notificationResponse?.payload ?? '');
    }
  }

  void _onResponse(NotificationResponse response) {
    _selectionController.add(response.payload ?? '');
  }

  Future<void> dispose() => _selectionController.close();
}
