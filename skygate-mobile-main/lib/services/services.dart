/// Barrel for the reusable services.
///
/// Every service is a framework neutral singleton reached through
/// `<Name>Service.instance`, so it works the same from a GetX controller, a
/// Cubit or a plain repository.
///
/// ```dart
/// import '../../services/services.dart';
///
/// final position = await LocationService.instance.getCurrentLocation();
/// ```
///
/// Services that need setup at startup: `LocalStorageService.init()`,
/// `SessionService.load()`, `NotificationService.init()` and
/// `PushNotificationService.init()` (after `Firebase.initializeApp()`).
library;

export 'audio_service.dart';
export 'biometric_auth_service.dart';
export 'database_service.dart';
export 'date_time_service.dart';
export 'file_picker_service.dart';
export 'http_service.dart';
export 'image_picker_service.dart';
export 'launcher_service.dart';
export 'local_storage_service.dart';
export 'location_service.dart';
export 'notification_service.dart';
export 'permission_service.dart';
export 'push_notification_service.dart';
export 'session_service.dart';
export 'toast_service.dart';
export 'validation_service.dart';
