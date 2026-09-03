import 'package:permission_handler/permission_handler.dart';

/// Runtime permissions.
///
/// Collapses `permission_handler` statuses into the three outcomes the UI
/// actually branches on, so screens stop repeating the same
/// `isGranted / isPermanentlyDenied` ladder.
enum AppPermissionStatus {
  granted,
  denied,

  /// Denied with "don't ask again": only the system settings screen can
  /// recover it, see [PermissionService.openSettings].
  permanentlyDenied,
}

class PermissionService {
  PermissionService._();

  static final PermissionService instance = PermissionService._();

  /// Requests [permission] and normalises the result.
  Future<AppPermissionStatus> request(Permission permission) async {
    final status = await permission.request();
    return _map(status);
  }

  /// Reads the current state without prompting the user.
  Future<AppPermissionStatus> check(Permission permission) async {
    final status = await permission.status;
    return _map(status);
  }

  /// Requests several permissions in one prompt sequence.
  Future<Map<Permission, AppPermissionStatus>> requestAll(
    List<Permission> permissions,
  ) async {
    final statuses = await permissions.request();
    return statuses.map((key, value) => MapEntry(key, _map(value)));
  }

  Future<AppPermissionStatus> requestCamera() => request(Permission.camera);

  Future<AppPermissionStatus> requestMicrophone() =>
      request(Permission.microphone);

  Future<AppPermissionStatus> requestPhotos() => request(Permission.photos);

  Future<AppPermissionStatus> requestStorage() => request(Permission.storage);

  Future<AppPermissionStatus> requestNotification() =>
      request(Permission.notification);

  Future<AppPermissionStatus> requestLocation() => request(Permission.location);

  /// Convenience check used by the passport scanner screens.
  Future<bool> hasCameraPermission() async =>
      await check(Permission.camera) == AppPermissionStatus.granted;

  /// Opens the app entry in the system settings so the user can flip a
  /// permanently denied permission.
  Future<bool> openSettings() => openAppSettings();

  AppPermissionStatus _map(PermissionStatus status) {
    if (status.isGranted || status.isLimited || status.isProvisional) {
      return AppPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return AppPermissionStatus.permanentlyDenied;
    }
    return AppPermissionStatus.denied;
  }
}
