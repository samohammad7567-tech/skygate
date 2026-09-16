import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/models/trip_lifecycle.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/user_profile_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/location_service.dart';
import 'package:skygate/core/services/realtime_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/map/models/geofence_model.dart';
import 'package:skygate/features/map/models/location_ping_model.dart';
import 'package:skygate/features/map/models/map_tracking_status.dart';
import 'package:skygate/features/trips/models/booking_trip_model.dart';

part 'map_state.dart';

/// What the server made of a location ping.
enum _PingOutcome {
  stored,

  /// 400/401 — the trip is not `started` any more, or the session is gone.
  /// Either way there is nothing to retry.
  refused,

  /// Network or server trouble. Worth trying again on the next tick.
  failed,
}

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  MapCubit get(BuildContext context) => BlocProvider.of(context);
  static const String protocolAcceptedKey = 'map_protocol_accepted';
  static const Duration _watchdogEvery = Duration(minutes: 1);

  MapTrackingStatus status = MapTrackingStatus.loading;
  String? errorMessage;
  UserProfileModel? user;
  BookingTripModel? activeBooking;
  bool hasFinishedTrip = false;
  LocationPoint? currentPoint;
  LocationPingModel? lastPing;
  LocationAccess access = LocationAccess.denied;
  List<TripGeofenceModel> geofences = const [];
  DateTime selectedDate = _dayOf(DateTime.now());

  /// The trip leader's last broadcast position, or null until the first
  /// `location.updated` arrives. Never draw a marker before then — (0, 0) puts
  /// the leader in the Atlantic.
  LocationPoint? leaderPoint;
  bool leaderOutsideSafeArea = false;

  /// Local inside/outside verdict, recomputed on every position fix so the
  /// warning appears without waiting for a ping round trip. The server owns the
  /// real decision and is the one that notifies the leader and admins — never
  /// raise an alert of our own from this flag.
  bool isOutsideSafeArea = false;

  /// Device clock, not the server's `recorded_at`: the two can disagree, and
  /// staleness is about how long *we* have been failing to report.
  DateTime? lastPingAt;

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
    final since = lastPingAt ?? lastPing?.recordedAt;
    return since == null ? null : DateTime.now().difference(since);
  }

  bool get hasAcceptedProtocol =>
      (CacheUtil.get(key: protocolAcceptedKey) as bool?) ?? false;

  TripLifecycle get lifecycle =>
      activeBooking?.tripStatus ?? TripLifecycle.unknown;

  /// `unknown` means the API did not report a trip status. Try anyway and let
  /// the first 400 settle it — that costs one request, where refusing outright
  /// would break tracking against an older backend.
  bool get _mayTrack =>
      lifecycle.allowsTracking || lifecycle == TripLifecycle.unknown;

  StreamSubscription<LocationPoint>? _positions;
  StreamSubscription<Map<String, dynamic>>? _leaderMoves;
  StreamSubscription<void>? _reconnects;
  Timer? _pinger;
  Timer? _watchdog;
  int _ticks = 0;
  DateTime? _trackingSince;

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

    if (lifecycle.isOver) {
      await _stopTracking();
      status = MapTrackingStatus.finished;
      emit(MapLoaded());
      return;
    }

    // `almost-done` keeps the chat but refuses pings, so the map stops without
    // pretending the trip is over.
    if (!_mayTrack) {
      await _stopTracking();
      status = lifecycle == TripLifecycle.almostDone
          ? MapTrackingStatus.wrappingUp
          : MapTrackingStatus.inactive;
      await _readActivities();
      _applyDate();
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

    await _startTracking();
    await Future.wait([_readActivities(), _readSafeArea()]);
    _applyDate();
    emit(MapLoaded());
  }

  Future<void> acceptProtocol() async {
    if (access == LocationAccess.deniedForever) {
      await LocationService.openSettings();
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
    if (await _ping(point) != _PingOutcome.stored) {
      emit(MapReconnectFailed(message: errorMessage ?? ApiError.generic));
      return;
    }

    await load(refresh: true);
  }

  void selectDate(DateTime date) {
    final day = _dayOf(date);
    if (day == selectedDate) return;
    selectedDate = day;
    _applyDate();
    emit(MapDateSelected());
  }

  void stepDay(int days) => selectDate(selectedDate.add(Duration(days: days)));
  ActivityModel? focusedActivity;

  void focusActivity(ActivityModel activity) {
    if (!activity.hasCoordinates || focusedActivity?.id == activity.id) return;
    focusedActivity = activity;
    emit(MapActivityFocused());
  }

  Future<void> _readBookings() async {
    final response = await DioService.get(ApiEndpoints.bookings);
    final bookings = ApiParse.rowsOf(
      response.data['data'],
      BookingTripModel.fromJson,
    );

    // A live trip wins over a merely confirmed booking; the fallback keeps the
    // screen working if the API omits `trip.status`.
    activeBooking =
        bookings
            .where((booking) => booking.tripStatus.allowsChat)
            .firstOrNull ??
        bookings
            .where(
              (booking) =>
                  booking.status == BookingStatus.active &&
                  !booking.tripStatus.isOver,
            )
            .firstOrNull;

    hasFinishedTrip = bookings.any(
      (booking) =>
          booking.tripStatus.isOver ||
          booking.status == BookingStatus.completed,
    );
  }

  Future<void> _readProfile() async {
    if (user != null) return;
    try {
      final response = await DioService.get(ApiEndpoints.home);
      final body = response.data['data'];
      user = UserProfileModel.of(body is Map ? body['user'] : null);
    } catch (error) {
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

  /// Reads the pilgrim's own safe areas. `app/trip-geofences` is the leader's
  /// route and answers 403 here, which is why nothing was ever drawn before.
  Future<void> _readSafeArea() async {
    try {
      final response = await DioService.get(ApiEndpoints.tripSafeArea);
      geofences = [
        for (final fence in ApiParse.rowsOf(
          response.data['data'],
          TripGeofenceModel.fromJson,
        ))
          if (fence.isDrawable) fence,
      ];
    } on DioException catch (error) {
      // 400 is the same gate as the pings: not on a started trip.
      debugPrint('MapCubit._readSafeArea error: ${error.response?.statusCode}');
      geofences = const [];
    } catch (error) {
      debugPrint('MapCubit._readSafeArea error: $error');
      geofences = const [];
    }
    _checkSafeArea();
  }

  void _applyDate() {
    activities = [
      for (final activity in _allActivities)
        if (activity.date != null && _dayOf(activity.date!) == selectedDate)
          activity,
    ]..sort((a, b) => (a.fromTime ?? '').compareTo(b.fromTime ?? ''));
    focusedActivity = null;
  }

  Future<void> _startTracking() async {
    status = MapTrackingStatus.active;
    if (_positions != null) return;

    // The position stream only moves the map. Pinging is on its own 60 second
    // clock so a pilgrim walking through the Haram does not ping every 20
    // seconds, and a pilgrim sitting still still reports in.
    _positions = LocationService.stream().listen(
      (point) {
        currentPoint = point;
        _checkSafeArea();
        emit(MapPositionChanged());
      },
      onError: (Object error) =>
          debugPrint('MapCubit position stream error: $error'),
    );

    _trackingSince = DateTime.now();
    _pinger = Timer.periodic(MapTrackingStatus.pingEvery, (_) => _onTick());
    _watchdog = Timer.periodic(_watchdogEvery, (_) => _checkStaleness());

    await _listenToLeader();
    unawaited(_firstFix());
  }

  Future<void> _listenToLeader() async {
    final tripId = activeBooking?.tripId;
    if (tripId == null || !RealtimeService.isAvailable) return;

    _leaderMoves ??= RealtimeService.leaderMoves.listen(_onLeaderMoved);

    // The socket replays nothing it missed, and safe areas are never broadcast
    // at all, so a reconnection is the cue to re-read them.
    _reconnects ??= RealtimeService.reconnects.listen((_) {
      unawaited(_refreshSafeArea());
    });

    await RealtimeService.joinLeader(tripId);
  }

  void _onLeaderMoved(Map<String, dynamic> payload) {
    final latitude = ApiParse.numOf(payload['latitude'])?.toDouble();
    final longitude = ApiParse.numOf(payload['longitude'])?.toDouble();
    if (latitude == null || longitude == null || isClosed) return;

    leaderPoint = LocationPoint(latitude: latitude, longitude: longitude);
    leaderOutsideSafeArea = payload['is_outside_geofence'] == true;
    emit(MapLeaderMoved());
  }

  Future<void> _onTick() async {
    _ticks++;
    final point = currentPoint;
    if (point != null) await _ping(point);

    if (_ticks % MapTrackingStatus.safeAreaEveryTicks == 0) {
      await _refreshSafeArea();
    }
  }

  Future<void> _refreshSafeArea() async {
    if (isClosed || status != MapTrackingStatus.active) return;

    final before = isOutsideSafeArea;
    final count = geofences.length;
    await _readSafeArea();
    if (isClosed) return;
    if (before != isOutsideSafeArea || count != geofences.length) {
      emit(MapSafeAreaChanged());
    }
  }

  Future<void> _firstFix() async {
    final point = await LocationService.current();
    if (point == null || isClosed) return;
    currentPoint = point;
    _checkSafeArea();
    await _ping(point);
    if (!isClosed) emit(MapPositionChanged());
  }

  Future<void> _stopTracking() async {
    await _positions?.cancel();
    _positions = null;
    await _leaderMoves?.cancel();
    _leaderMoves = null;
    await _reconnects?.cancel();
    _reconnects = null;
    _pinger?.cancel();
    _pinger = null;
    _watchdog?.cancel();
    _watchdog = null;
    _ticks = 0;
    _trackingSince = null;
    leaderPoint = null;
    leaderOutsideSafeArea = false;

    final tripId = activeBooking?.tripId;
    if (tripId != null) await RealtimeService.leaveLeader(tripId);
  }

  Future<_PingOutcome> _ping(LocationPoint point) async {
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
      lastPingAt = DateTime.now();

      if (status == MapTrackingStatus.disconnected && !isClosed) {
        status = MapTrackingStatus.active;
        emit(MapLoaded());
      }
      return _PingOutcome.stored;
    } on DioException catch (error) {
      final code = error.response?.statusCode;
      errorMessage = ApiError.messageOf(error);

      // 400 means the trip left `started`; 401 means the session is gone.
      // Repeating either every minute burns battery and data for nothing.
      if (code == 400 || code == 401) {
        debugPrint('MapCubit._ping refused ($code) — stopping tracking');
        await _stopTracking();
        if (!isClosed) await load(refresh: true);
        return _PingOutcome.refused;
      }

      debugPrint('MapCubit._ping error: $error');
      return _PingOutcome.failed;
    } catch (error) {
      debugPrint('MapCubit._ping error: $error');
      errorMessage = ApiError.messageOf(error);
      return _PingOutcome.failed;
    }
  }

  /// UI courtesy only: colours the banner before the push notification lands.
  void _checkSafeArea() {
    final point = currentPoint;
    if (point == null || geofences.isEmpty) {
      isOutsideSafeArea = false;
      return;
    }

    // Inside means inside at least one active circle — a leader may draw one
    // around the Haram and another around the hotel.
    isOutsideSafeArea = !geofences.any(
      (fence) => fence.contains(point.latitude, point.longitude),
    );
  }

  Future<void> _checkStaleness() async {
    if (status != MapTrackingStatus.active) return;

    // Until the first ping lands, measure from when tracking began — a slow
    // first GPS fix is not a lost signal.
    final since = lastPingAt ?? _trackingSince;
    if (since == null ||
        DateTime.now().difference(since) < MapTrackingStatus.staleAfter) {
      return;
    }

    status = MapTrackingStatus.disconnected;
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
