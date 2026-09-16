import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

enum LocationAccess {
  granted,
  serviceOff,
  denied,
  deniedForever;

  bool get isGranted => this == LocationAccess.granted;
}

@immutable
class LocationPoint {
  const LocationPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
  static LocationPoint? of(LocationData? data) {
    final lat = data?.latitude;
    final lng = data?.longitude;
    if (lat == null || lng == null) return null;
    return LocationPoint(latitude: lat, longitude: lng);
  }

  @override
  bool operator ==(Object other) =>
      other is LocationPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => '$latitude, $longitude';
}

class LocationService {
  LocationService._();

  static final Location _location = Location();
  static const int _distanceFilterMeters = 25;
  static const int _intervalMs = 10000;

  static bool _configured = false;
  static Future<LocationAccess> check() async {
    if (!await _location.serviceEnabled()) return LocationAccess.serviceOff;
    return _map(await _location.hasPermission());
  }

  static Future<LocationAccess> request() async {
    if (!await _location.serviceEnabled() &&
        !await _location.requestService()) {
      return LocationAccess.serviceOff;
    }

    final held = await _location.hasPermission();
    if (_map(held).isGranted) return LocationAccess.granted;
    if (held == PermissionStatus.deniedForever) {
      return LocationAccess.deniedForever;
    }

    return _map(await _location.requestPermission());
  }

  static Future<LocationPoint?> current() async {
    if (!(await check()).isGranted) return null;
    await _configure();
    try {
      return LocationPoint.of(await _location.getLocation());
    } catch (error) {
      debugPrint('LocationService.current error: $error');
      return null;
    }
  }

  static Stream<LocationPoint> stream() async* {
    await _configure();
    yield* _location.onLocationChanged
        .map(LocationPoint.of)
        .where((point) => point != null)
        .cast<LocationPoint>();
  }

  static Future<void> openSettings() async {
    try {
      await handler.openAppSettings();
    } catch (error) {
      debugPrint('LocationService.openSettings error: $error');
    }
  }

  static Future<void> setBackgroundMode(bool enabled) async {
    try {
      await _location.enableBackgroundMode(enable: enabled);
    } catch (error) {
      debugPrint('LocationService.setBackgroundMode error: $error');
    }
  }

  static Future<void> _configure() async {
    if (_configured) return;
    _configured = true;
    try {
      await _location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: _intervalMs,
        distanceFilter: _distanceFilterMeters.toDouble(),
      );
    } catch (error) {
      debugPrint('LocationService.configure error: $error');
      _configured = false;
    }
  }

  static LocationAccess _map(PermissionStatus status) => switch (status) {
    PermissionStatus.granted ||
    PermissionStatus.grantedLimited => LocationAccess.granted,
    PermissionStatus.deniedForever => LocationAccess.deniedForever,
    PermissionStatus.denied => LocationAccess.denied,
  };
}
