import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/time_progress.dart';
import 'package:skygate/core/models/trip_model.dart';

class ActivityDayModel {
  ActivityDayModel({
    required this.number,
    required this.date,
    required this.activities,
  });
  final int number;

  final DateTime? date;
  final List<ActivityModel> activities;
  static List<ActivityDayModel> daysFrom(List<TripActivityModel> data) {
    final byDate = <DateTime, List<ActivityModel>>{};

    for (final item in data) {
      final activity = ActivityModel.fromActivity(item);
      final date = activity.date;
      if (date == null) continue;
      byDate.putIfAbsent(date, () => []).add(activity);
    }

    final dates = byDate.keys.toList()..sort();

    return [
      for (var i = 0; i < dates.length; i++)
        ActivityDayModel(
          number: i + 1,
          date: dates[i],
          activities: byDate[dates[i]]!
            ..sort((a, b) => (a.fromTime ?? '').compareTo(b.fromTime ?? '')),
        ),
    ];
  }
}

class ActivityModel {
  int? id;
  String? title;
  DateTime? date;
  String? place;
  String? meetingPoint;
  double? latitude;
  double? longitude;

  String? fromTime;
  String? toTime;
  String? typeName;
  Color? typeColor;
  String? status;

  TimeProgress progress = TimeProgress.upcoming;

  /// Flipped straight after the pilgrim taps, so the card settles into its
  /// done state without waiting for the list to be re-read.
  bool hasConfirmedAttendance = false;
  bool hasRated = false;

  ActivityKind kind = ActivityKind.rituals;
  ActivityModel.fromActivity(TripActivityModel activity) {
    final type = activity.activityType;

    id = activity.id;
    title = activity.title;
    date = activity.activityDate;
    place = activity.meetingPointText;
    meetingPoint = _coordinates(
      activity.meetingPointLat,
      activity.meetingPointLng,
    );
    latitude = activity.meetingPointLat?.toDouble();
    longitude = activity.meetingPointLng?.toDouble();
    fromTime = activity.startTime;
    toTime = activity.endTime;
    status = activity.status;
    progress = TimeProgress.fromApi(activity.status);
    hasConfirmedAttendance = _attended(activity.attendanceStatus);
    hasRated = (activity.feedbackRating ?? 0) > 0;
    typeName = type?.name;
    typeColor = _color(type?.color);
    kind = ActivityKind.fromApi(typeName ?? type?.icon);
  }
  bool get hasCoordinates => latitude != null && longitude != null;

  /// What the card's bottom button offers, if anything: a finished activity
  /// is rated, a live or coming one is checked into, and each turns into its
  /// settled twin once done.
  ActivityAction get action {
    if (progress == TimeProgress.finished) {
      return hasRated ? ActivityAction.rated : ActivityAction.rate;
    }
    return hasConfirmedAttendance
        ? ActivityAction.attendanceConfirmed
        : ActivityAction.confirmAttendance;
  }

  static bool _attended(String? value) {
    final label = value?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return false;
    return [
      'present',
      'attended',
      'confirmed',
      'حاضر',
      'حضر',
    ].any(label.contains);
  }

  Color get accentColor => typeColor ?? kind.color;
  Color get surfaceColor => typeColor?.withValues(alpha: 0.15) ?? kind.surface;

  static String? _coordinates(num? lat, num? lng) =>
      lat == null || lng == null ? null : '$lat, $lng';
  static Color? _color(String? hex) {
    if (hex == null) return null;
    final digits = hex.replaceAll('#', '').trim();
    if (digits.length != 6 && digits.length != 8) return null;
    final value = int.tryParse(digits.padLeft(8, 'F'), radix: 16);
    return value == null ? null : Color(value);
  }
}

/// The single action a card offers at its foot.
enum ActivityAction {
  confirmAttendance('confirm_attendance'),
  attendanceConfirmed('attendance_confirmed'),
  rate('rate_activity'),
  rated('activity_rated');

  const ActivityAction(this.labelKey);

  final String labelKey;

  /// The two live actions are filled buttons; their settled twins are
  /// outlines that no longer respond.
  bool get isDone =>
      this == ActivityAction.attendanceConfirmed ||
      this == ActivityAction.rated;
}

enum ActivityKind {
  prayers(
    'prayers',
    'activity_prayers',
    JourneyAssets.prayers,
    AppColors.primary,
    AppColors.prayerSurface,
  ),
  stay(
    'stay',
    'activity_stay',
    JourneyAssets.stay,
    AppColors.accent,
    AppColors.staySurface,
  ),
  rituals(
    'rituals',
    'activity_rituals',
    JourneyAssets.rituals,
    AppColors.ritual,
    AppColors.ritualSurface,
  );

  const ActivityKind(
    this.slug,
    this.labelKey,
    this.icon,
    this.color,
    this.surface,
  );

  final String slug;
  final String labelKey;
  final String icon;
  final Color color;
  final Color surface;

  static ActivityKind fromSlug(String? slug) => values.firstWhere(
    (kind) => kind.slug == slug,
    orElse: () => ActivityKind.rituals,
  );
  static ActivityKind fromApi(String? type) {
    final value = type?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return rituals;

    bool has(List<String> words) => words.any(value.contains);

    if (has(['pray', 'salah', 'صلا', 'صلو'])) return prayers;
    if (has([
      'stay',
      'rest',
      'hotel',
      'sleep',
      'إقام',
      'اقام',
      'راح',
      'فندق',
    ])) {
      return stay;
    }
    return rituals;
  }
}
