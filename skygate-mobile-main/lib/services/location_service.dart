import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// Outcome of a location request, so callers can tell "user said no" apart from
/// "location is off" without inspecting plugin enums.
enum LocationResultStatus {
  success,
  serviceDisabled,
  permissionDenied,
  failed,
}

/// A location request result: [position] is only set when [status] is
/// [LocationResultStatus.success].
class LocationResult {
  const LocationResult({required this.status, this.position});

  const LocationResult.success(LatLng position)
      : this(status: LocationResultStatus.success, position: position);

  const LocationResult.failure(LocationResultStatus status)
      : this(status: status);

  final LocationResultStatus status;
  final LatLng? position;

  bool get isSuccess => status == LocationResultStatus.success;
}

/// Device location: service state, runtime permission and current position.
///
/// Returns `google_maps_flutter` [LatLng] because every caller feeds the result
/// straight into a map or a coordinate pair.
class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  final Location _location = Location();

  /// Ensures location services are switched on, prompting the user if needed.
  Future<bool> ensureServiceEnabled() async {
    if (await _location.serviceEnabled()) return true;
    return _location.requestService();
  }

  /// Ensures the app holds a usable location permission, prompting if needed.
  Future<bool> ensurePermissionGranted() async {
    var permission = await _location.hasPermission();

    final needsRequest = permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever ||
        permission == PermissionStatus.grantedLimited;

    if (needsRequest) {
      permission = await _location.requestPermission();
    }

    return permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;
  }

  /// Resolves the current position, requesting the service and the permission
  /// first. The returned [LocationResult] says why it failed when it did.
  Future<LocationResult> getCurrentLocation() async {
    if (!await ensureServiceEnabled()) {
      return const LocationResult.failure(LocationResultStatus.serviceDisabled);
    }

    if (!await ensurePermissionGranted()) {
      return const LocationResult.failure(
        LocationResultStatus.permissionDenied,
      );
    }

    try {
      final data = await _location.getLocation();
      final latitude = data.latitude;
      final longitude = data.longitude;

      if (latitude == null || longitude == null) {
        return const LocationResult.failure(LocationResultStatus.failed);
      }
      return LocationResult.success(LatLng(latitude, longitude));
    } catch (_) {
      return const LocationResult.failure(LocationResultStatus.failed);
    }
  }

  /// Continuous position updates. Callers must cancel their subscription.
  Stream<LatLng> watchLocation() {
    return _location.onLocationChanged
        .where((data) => data.latitude != null && data.longitude != null)
        .map((data) => LatLng(data.latitude!, data.longitude!));
  }

  /// Raw plugin data, for the rare caller that needs accuracy, speed or
  /// heading alongside the coordinates.
  Future<LocationData> getRawLocation() => _location.getLocation();

  /// Tunes how often and how precisely updates are produced.
  Future<bool> changeSettings({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int intervalMs = 1000,
    double distanceFilter = 0,
  }) {
    return _location.changeSettings(
      accuracy: accuracy,
      interval: intervalMs,
      distanceFilter: distanceFilter,
    );
  }
}
