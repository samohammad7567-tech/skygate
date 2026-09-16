import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/services/location_service.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/map/models/geofence_model.dart';
import 'package:skygate/features/map/utils/map_marker_factory.dart';

class MapCanvas extends StatefulWidget {
  const MapCanvas({
    super.key,
    required this.position,
    required this.activities,
    required this.geofences,
    this.avatarUrl,
    this.focused,
    this.leaderPosition,
    this.leaderOutside = false,
  });
  final LocationPoint? position;
  final List<ActivityModel> activities;

  final List<TripGeofenceModel> geofences;
  final String? avatarUrl;
  final ActivityModel? focused;

  /// Null until the leader's first `location.updated` arrives — and it may
  /// never arrive, if their phone is off. Nothing is drawn in that case: a
  /// marker at (0, 0) would sit in the Atlantic.
  final LocationPoint? leaderPosition;
  final bool leaderOutside;
  static const CameraPosition _fallbackCamera = CameraPosition(
    target: LatLng(21.4225, 39.8262),
    zoom: 14.5,
  );

  @override
  State<MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends State<MapCanvas> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<String, BitmapDescriptor> _pins = {};
  Set<Marker> _markers = const {};
  Set<Circle> _circles = const {};
  bool _centred = false;

  @override
  void initState() {
    super.initState();
    _rebuildCircles();
    _rebuildMarkers();
    _loadPins();
  }

  @override
  void didUpdateWidget(covariant MapCanvas old) {
    super.didUpdateWidget(old);
    if (old.activities != widget.activities ||
        old.avatarUrl != widget.avatarUrl) {
      _loadPins();
    }
    if (old.geofences != widget.geofences) _rebuildCircles();
    if (old.activities != widget.activities ||
        old.position != widget.position ||
        old.leaderPosition != widget.leaderPosition ||
        old.leaderOutside != widget.leaderOutside) {
      _rebuildMarkers();
    }
    if (old.focused?.id != widget.focused?.id) _focusActivity();
    _followFirstFix();
  }

  Future<void> _focusActivity() async {
    final activity = widget.focused;
    if (activity == null || !_controller.isCompleted) return;
    _centred = true;

    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(activity.latitude!, activity.longitude!),
        16.5,
      ),
    );
  }

  Future<void> _loadPins() async {
    final pilgrim = await MapMarkerFactory.pilgrimPin(
      color: AppColors.success,
      avatarUrl: ApiEndpoints.mediaUrl(widget.avatarUrl),
    );
    final leader = await MapMarkerFactory.activityPin(
      asset: SosAssets.tripLeader,
      color: widget.leaderOutside ? AppColors.error : AppColors.accent,
    );

    final activityPins = <String, BitmapDescriptor>{};
    for (final kind in widget.activities.map((a) => a.kind).toSet()) {
      activityPins[kind.slug] = await MapMarkerFactory.activityPin(
        asset: kind.icon,
        color: kind.color,
      );
    }

    if (!mounted) return;
    setState(() {
      _pins
        ..['pilgrim'] = pilgrim
        ..['leader'] = leader
        ..addAll(activityPins);
    });
    _rebuildMarkers();
  }

  Future<void> _followFirstFix() async {
    final position = widget.position;
    if (_centred || position == null || !_controller.isCompleted) return;
    _centred = true;

    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        15.5,
      ),
    );
  }

  /// Marker and circle sets are cached rather than rebuilt on every `build`.
  /// Handing GoogleMap a fresh set each frame makes it drop and recreate every
  /// marker, which shows up as a visible flicker.
  void _rebuildMarkers() {
    final markers = <Marker>{};
    final position = widget.position;

    if (position != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pilgrim'),
          position: LatLng(position.latitude, position.longitude),
          icon:
              _pins['pilgrim'] ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          anchor: const Offset(0.5, 1),
          zIndexInt: 2,
        ),
      );
    }

    final leader = widget.leaderPosition;
    if (leader != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('leader'),
          position: LatLng(leader.latitude, leader.longitude),
          icon:
              _pins['leader'] ??
              BitmapDescriptor.defaultMarkerWithHue(
                widget.leaderOutside
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueOrange,
              ),
          anchor: const Offset(0.5, 1),
          infoWindow: InfoWindow(title: 'map_trip_leader'.tr()),
          zIndexInt: 3,
        ),
      );
    }

    for (final activity in widget.activities) {
      markers.add(
        Marker(
          markerId: MarkerId('activity_${activity.id}'),
          position: LatLng(activity.latitude!, activity.longitude!),
          icon:
              _pins[activity.kind.slug] ??
              BitmapDescriptor.defaultMarkerWithHue(_hueOf(activity.kind)),
          anchor: const Offset(0.5, 1),
          infoWindow: InfoWindow(
            title: activity.title,
            snippet: activity.place,
          ),
        ),
      );
    }

    if (!mounted) return;
    setState(() => _markers = markers);
  }

  /// Every active circle, not just the first: a leader may ring the Haram and
  /// the hotel separately.
  void _rebuildCircles() {
    final circles = {
      for (final fence in widget.geofences)
        Circle(
          circleId: CircleId('geofence_${fence.id}'),
          center: LatLng(fence.latitude!, fence.longitude!),
          radius: fence.radiusMeters!,
          strokeWidth: 2,
          strokeColor: AppColors.success,
          fillColor: AppColors.success.withValues(alpha: 0.06),
        ),
    };

    if (!mounted) return;
    setState(() => _circles = circles);
  }

  static double _hueOf(ActivityKind kind) => switch (kind) {
    ActivityKind.prayers => BitmapDescriptor.hueAzure,
    ActivityKind.stay => BitmapDescriptor.hueOrange,
    ActivityKind.rituals => BitmapDescriptor.hueViolet,
  };

  @override
  Widget build(BuildContext context) {
    final position = widget.position;

    return Stack(
      fit: StackFit.expand,
      children: [
        GoogleMap(
          initialCameraPosition: position == null
              ? MapCanvas._fallbackCamera
              : CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 15.5,
                ),
          markers: _markers,
          circles: _circles,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          onMapCreated: (controller) {
            if (!_controller.isCompleted) _controller.complete(controller);
            _followFirstFix();
          },
        ),
        if (position == null) const _AwaitingFix(),
      ],
    );
  }
}

class _AwaitingFix extends StatelessWidget {
  const _AwaitingFix();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(MapAssets.trackingPreview, fit: BoxFit.cover),
          ColoredBox(
            color: theme.colorScheme.surface.withValues(alpha: 0.72),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 22.s,
                    width: 22.s,
                    child: CircularProgressIndicator(strokeWidth: 2.s),
                  ),
                  SizedBox(height: 12.s),
                  Text(
                    'map_awaiting_fix'.tr(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
