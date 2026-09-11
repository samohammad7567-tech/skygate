import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/user_profile_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/location_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/features/map/models/geofence_model.dart';
import 'package:skygate/features/map/models/location_ping_model.dart';
import 'package:skygate/features/map/models/map_tracking_status.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  MapCubit get(BuildContext context) => BlocProvider.of(context);
  static const String protocolAcceptedKey = 'map_protocol_accepted';
  static const Duration _heartbeatEvery = Duration(minutes: 5);
  static const Duration _watchdogEvery = Duration(minutes: 1);

  // ── What the screen renders ────────────────────────────────────────────
  MapTrackingStatus status = MapTrackingStatus.loading;
  String? errorMessage;
  UserProfileModel? user;
  BookingTripModel? activeBooking;
  bool hasFinishedTrip = false;
  LocationPoint? currentPoint;
  LocationPingModel? lastPing;
  LocationAccess access = LocationAccess.denied;
  List<TripGeofenceModel> geofences = const [];
  GeofenceBreachModel? breach;

  // ── The day being shown ────────────────────────────────────────────────
  DateTime selectedDate = _dayOf(DateTime.now());
  List<ActivityModel> _allActivities = const [];
  List<ActivityModel> activities = const [];
  List<ActivityKind> get legend {
    final kinds = activities.map((activity) => activity.kind).toSet();
    return ActivityKind.values.where(kinds.contains).toList();
  }

  List<ActivityModel> get pinnedActivities => [
    for (final activity in activities)
      if (activity.hasCoordinates) activity,
  ];
  Duration? get outageFor {
    final since = lastPing?.recordedAt ?? breach?.lastSeenAt;
    return since == null ? null : DateTime.now().difference(since);
  }

  bool get hasAcceptedProtocol =>
      (CacheUtil.get(key: protocolAcceptedKey) as bool?) ?? false;

  StreamSubscription<LocationPoint>? _positions;
  Timer? _heartbeat;
  Timer? _watchdog;

  // ── Opening the tab ────────────────────────────────────────────────────
  Future<void> load({bool refresh = false}) async {
    if (!refresh) emit(MapLoading());
    errorMessage = null;

    try {
      await Future.wait([_readBookings(), _readProfile()]);
    } catch (error) {
      debugPrint('MapCubit.load error: $error');
      errorMessage = ApiError.messageOf(error);
    }

    if (activeBooking == null) {
      await _stopTracking();
      status = hasFinishedTrip
          ? MapTrackingStatus.finished
          : MapTrackingStatus.inactive;
      emit(MapLoaded());
      return;
    }

    access = await LocationService.check();
    if (!access.isGranted || !hasAcceptedProtocol) {
      await _stopTracking();
      status = MapTrackingStatus.consent;
      emit(MapLoaded());
      return;
    }

    _startTracking();
    // The reads below fill the live view in; a trip whose programme or safe
    // areas failed to load still shows a reporting map.
    await Future.wait([_readActivities(), _readGeofences()]);
    _applyDate();
    emit(MapLoaded());
  }

  // ── The protocol card ──────────────────────────────────────────────────
  Future<void> acceptProtocol() async {
    // Once the OS has been told "never", it raises no prompt at all, so the
    // button's only remaining job is to open the settings page where the
    // pilgrim can undo it by hand.
    if (access == LocationAccess.deniedForever) {
      await LocationService.openSettings();
      // The permission may well have been granted while the app was away, so
      // the tab re-reads it on the way back rather than staying on the card.
      await load(refresh: true);
      return;
    }

    emit(MapPermissionRequesting());

    access = await LocationService.request();
    if (!access.isGranted) {
      status = MapTrackingStatus.consent;
      emit(MapPermissionDenied(access: access));
      return;
    }

    await CacheUtil.setBool(key: protocolAcceptedKey, value: true);
    await load(refresh: true);
  }

  // ── The outage card ────────────────────────────────────────────────────
  Future<void> reconnect() async {
    emit(MapReconnecting());

    access = await LocationService.check();
    if (!access.isGranted) {
      status = MapTrackingStatus.consent;
      emit(MapLoaded());
      return;
    }

    final point = await LocationService.current();
    if (point == null) {
      errorMessage = 'map_gps_no_fix';
      emit(MapReconnectFailed(message: errorMessage!));
      return;
    }

    currentPoint = point;
    final sent = await _ping(point);
    if (!sent) {
      emit(MapReconnectFailed(message: errorMessage ?? ApiError.generic));
      return;
    }

    await load(refresh: true);
  }

  // ── The date bar ───────────────────────────────────────────────────────
  void selectDate(DateTime date) {
    final day = _dayOf(date);
    if (day == selectedDate) return;
    selectedDate = day;
    _applyDate();
    emit(MapDateSelected());
  }

  void stepDay(int days) => selectDate(selectedDate.add(Duration(days: days)));

  // ── The activities list ────────────────────────────────────────────────
  ActivityModel? focusedActivity;

  void focusActivity(ActivityModel activity) {
    if (!activity.hasCoordinates || focusedActivity?.id == activity.id) return;
    focusedActivity = activity;
    emit(MapActivityFocused());
  }

  // ── Reads ──────────────────────────────────────────────────────────────
  Future<void> _readBookings() async {
    final response = await DioService.get(ApiEndpoints.bookings);
    final bookings = ApiParse.listOf(
      response.data['data'],
      BookingTripModel.fromJson,
    );

    activeBooking = bookings
        .where((booking) => booking.status == BookingStatus.active)
        .firstOrNull;
    hasFinishedTrip = bookings.any(
      (booking) => booking.status == BookingStatus.completed,
    );
  }

  Future<void> _readProfile() async {
    if (user != null) return;
    try {
      final response = await DioService.get(ApiEndpoints.home);
      final body = response.data['data'];
      user = UserProfileModel.of(body is Map ? body['user'] : null);
    } catch (error) {
      // The name is decoration on cards that read fine without it.
      debugPrint('MapCubit._readProfile error: $error');
    }
  }

  Future<void> _readActivities() async {
    try {
      final response = await DioService.get(ApiEndpoints.activities);
      _allActivities = [
        for (final item in ApiParse.listOf(
          response.data['data'],
          TripActivityModel.fromJson,
        ))
          ActivityModel.fromActivity(item),
      ];
    } catch (error) {
      debugPrint('MapCubit._readActivities error: $error');
      _allActivities = const [];
      errorMessage = ApiError.messageOf(error);
    }
  }

  Future<void> _readGeofences() async {
    try {
      final response = await DioService.get(ApiEndpoints.tripGeofences);
      geofences = [
        for (final fence in ApiParse.rowsOf(
          response.data['data'],
          TripGeofenceModel.fromJson,
        ))
          if (fence.isDrawable) fence,
      ];
    } catch (error) {
      // A trip with no safe areas published answers 403 here rather than an
      // empty list, and an undrawn ring must not cost the pilgrim their map.
      debugPrint('MapCubit._readGeofences error: $error');
      geofences = const [];
    }
  }

  Future<void> _readBreach() async {
    try {
      final response = await DioService.get(ApiEndpoints.geofenceBreaches);
      final rows = ApiParse.rowsOf(
        response.data['data'],
        GeofenceBreachModel.fromJson,
      );
      final id = user?.id;
      breach =
          rows.where((row) => id == null || row.pilgrimId == id).firstOrNull ??
          rows.firstOrNull;
    } catch (error) {
      debugPrint('MapCubit._readBreach error: $error');
      breach = null;
    }
  }

  void _applyDate() {
    activities = [
      for (final activity in _allActivities)
        if (activity.date != null && _dayOf(activity.date!) == selectedDate)
          activity,
    ]..sort((a, b) => (a.fromTime ?? '').compareTo(b.fromTime ?? ''));

    // The day changed under it, so whatever the camera was looking at is no
    // longer on the list.
    focusedActivity = null;
  }

  // ── Reporting ──────────────────────────────────────────────────────────
  void _startTracking() {
    status = MapTrackingStatus.active;
    if (_positions != null) return;

    _positions = LocationService.stream().listen(
      (point) {
        currentPoint = point;
        _ping(point);
        emit(MapPositionChanged());
      },
      onError: (Object error) =>
          debugPrint('MapCubit position stream error: $error'),
    );

    _heartbeat = Timer.periodic(_heartbeatEvery, (_) {
      final point = currentPoint;
      if (point != null) _ping(point);
    });

    _watchdog = Timer.periodic(_watchdogEvery, (_) => _checkStaleness());

    unawaited(_firstFix());
  }

  Future<void> _firstFix() async {
    final point = await LocationService.current();
    if (point == null || isClosed) return;
    currentPoint = point;
    await _ping(point);
    if (!isClosed) emit(MapPositionChanged());
  }

  Future<void> _stopTracking() async {
    await _positions?.cancel();
    _positions = null;
    _heartbeat?.cancel();
    _heartbeat = null;
    _watchdog?.cancel();
    _watchdog = null;
  }

  Future<bool> _ping(LocationPoint point) async {
    try {
      final response = await DioService.post(
        ApiEndpoints.locationPings,
        data: LocationPingModel.body(
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      );
      final body = response.data['data'];
      lastPing = LocationPingModel.fromJson(
        body is Map<String, dynamic> ? body : const {},
      );

      // A ping that lands is what ends an outage.
      if (status == MapTrackingStatus.disconnected && !isClosed) {
        status = MapTrackingStatus.active;
        breach = null;
        emit(MapLoaded());
      }
      return true;
    } catch (error) {
      debugPrint('MapCubit._ping error: $error');
      errorMessage = ApiError.messageOf(error);
      return false;
    }
  }

  Future<void> _checkStaleness() async {
    if (status != MapTrackingStatus.active) return;

    final since = lastPing?.recordedAt;
    if (since != null &&
        DateTime.now().difference(since) < MapTrackingStatus.staleAfter) {
      return;
    }

    status = MapTrackingStatus.disconnected;
    await _readBreach();
    if (!isClosed) emit(MapLoaded());
  }

  static DateTime _dayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  Future<void> close() async {
    await _stopTracking();
    return super.close();
  }
}
