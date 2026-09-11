import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/core/services/location_service.dart';
import 'package:skygate/core/models/activity_model.dart';
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
  });
  final LocationPoint? position;
  final List<ActivityModel> activities;

  final List<TripGeofenceModel> geofences;
  final String? avatarUrl;
  final ActivityModel? focused;
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
  bool _centred = false;

  @override
  void initState() {
    super.initState();
    _loadPins();
  }

  @override
  void didUpdateWidget(covariant MapCanvas old) {
    super.didUpdateWidget(old);
    if (old.activities != widget.activities ||
        old.avatarUrl != widget.avatarUrl) {
      _loadPins();
    }
    if (old.focused?.id != widget.focused?.id) _focusActivity();
    _followFirstFix();
  }

  Future<void> _focusActivity() async {
    final activity = widget.focused;
    if (activity == null || !_controller.isCompleted) return;

    // The pilgrim asked to look somewhere, so the first-fix recentre must not
    // yank the camera back afterwards.
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
        ..addAll(activityPins);
    });
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

  Set<Marker> get _markers {
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

    return markers;
  }

  Set<Circle> get _circles => {
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
          // The pilgrim's own painted pin is the blue dot's job here, and two
          // markers on one point would only fight each other.
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
                  const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 12),
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
