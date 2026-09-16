import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerFactory {
  MapMarkerFactory._();
  static const double _width = 46;
  static const double _aspect = 1.32;
  static const double _scale = 3;

  static final Map<String, BitmapDescriptor> _cache = {};
  static Future<BitmapDescriptor> activityPin({
    required String asset,
    required Color color,
  }) => _cached('activity:$asset:${color.toARGB32()}', () async {
    final glyph = await _loadSvg(asset);
    final pin = await _paint(
      color: color,
      contentScale: 0.72,
      content: (canvas, center, radius) {
        if (glyph == null) return;
        _drawPicture(canvas, glyph, center: center, size: radius);
      },
    );
    glyph?.picture.dispose();
    return pin;
  });
  static Future<BitmapDescriptor> pilgrimPin({
    required Color color,
    String? avatarUrl,
  }) => _cached('pilgrim:${color.toARGB32()}:${avatarUrl ?? ''}', () async {
    final avatar = await _loadImage(avatarUrl);
    final pin = await _paint(
      color: color,
      contentScale: 1,
      tintContent: false,
      content: (canvas, center, radius) {
        if (avatar == null) return;
        final rect = Rect.fromCircle(center: center, radius: radius);
        canvas
          ..save()
          ..clipPath(Path()..addOval(rect));
        paintImage(
          canvas: canvas,
          rect: rect,
          image: avatar,
          fit: BoxFit.cover,
        );
        canvas.restore();
      },
    );
    avatar?.dispose();
    return pin;
  });
  static void clear() => _cache.clear();

  static Future<BitmapDescriptor> _cached(
    String key,
    Future<BitmapDescriptor> Function() build,
  ) async {
    final hit = _cache[key];
    if (hit != null) return hit;
    return _cache[key] = await build();
  }

  static Future<BitmapDescriptor> _paint({
    required Color color,
    required void Function(Canvas canvas, Offset center, double radius) content,
    required double contentScale,
    bool tintContent = true,
  }) async {
    final width = _width * _scale;
    final height = width * _aspect;
    final radius = width / 2;
    final center = Offset(radius, radius);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawPath(
      _dropPath(radius: radius, height: height),
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );

    final plateRadius = radius * 0.62;
    canvas.drawCircle(
      center,
      plateRadius,
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    if (tintContent) {
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, width, height),
        Paint()..colorFilter = ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    content(canvas, center, plateRadius * contentScale);
    if (tintContent) canvas.restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.round(), height.round());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();

    return BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      width: _width,
      height: _width * _aspect,
    );
  }

  static Path _dropPath({required double radius, required double height}) {
    final center = Offset(radius, radius);
    final spread = radius * 0.62;
    final shoulder = radius + radius * 0.78;

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..moveTo(radius - spread, shoulder)
      ..quadraticBezierTo(radius - spread * 0.35, height * 0.86, radius, height)
      ..quadraticBezierTo(
        radius + spread * 0.35,
        height * 0.86,
        radius + spread,
        shoulder,
      )
      ..close();
  }

  static void _drawPicture(
    Canvas canvas,
    PictureInfo info, {
    required Offset center,
    required double size,
  }) {
    final source = info.size;
    if (source.isEmpty) return;

    final scale = (size * 2) / source.longestSide;
    canvas
      ..save()
      ..translate(
        center.dx - source.width * scale / 2,
        center.dy - source.height * scale / 2,
      )
      ..scale(scale)
      ..drawPicture(info.picture)
      ..restore();
  }

  static Future<PictureInfo?> _loadSvg(String asset) async {
    try {
      return await vg.loadPicture(SvgAssetLoader(asset), null);
    } catch (error) {
      debugPrint('MapMarkerFactory._loadSvg($asset) error: $error');
      return null;
    }
  }

  static Future<ui.Image?> _loadImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final data = await NetworkAssetBundle(Uri.parse(url)).load('');
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: (_width * _scale).round(),
      );
      final frame = await codec.getNextFrame();
      codec.dispose();
      return frame.image;
    } catch (error) {
      debugPrint('MapMarkerFactory._loadImage error: $error');
      return null;
    }
  }
}
