import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/utils/api_parse.dart';

/// One tab of "تفاصيل الأنشطة" and the activities scheduled for it.
///
/// `GET app/activities` answers with one flat list covering the whole trip, so
/// the days are cut here rather than on the backend.
class ActivityDayModel {
  ActivityDayModel({required this.number, required this.date, required this.activities});

  /// 1-based place in the programme, printed on the tab.
  final int number;

  final DateTime? date;
  final List<ActivityModel> activities;

  /// Groups a flat `data[]` into day tabs, ordered by date, each day's
  /// activities ordered by their start time.
  static List<ActivityDayModel> daysFrom(List<dynamic> data) {
    final byDate = <DateTime, List<ActivityModel>>{};

    for (final item in data) {
      if (item is! Map<String, dynamic>) continue;
      final activity = ActivityModel.fromJson(item);
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

/// One card on the activities timeline.
class ActivityModel {
  int? id;
  String? title;

  /// Day the activity runs on; what the tabs are cut by.
  DateTime? date;

  /// The meeting point as the API words it — "أمام البوابة رقم ٣".
  String? place;

  /// Its coordinates, printed under the pin.
  String? meetingPoint;

  String? fromTime;
  String? toTime;

  /// The API's own name for the kind of activity, e.g. "زيارة".
  String? typeName;

  ActivityKind kind = ActivityKind.rituals;

  ActivityModel.fromJson(Map<String, dynamic> json) {
    final type = json['activity_type'];
    final typeJson = type is Map<String, dynamic> ? type : const {};

    id = ApiParse.intOf(json['id']);
    title = ApiParse.stringOf(json['title']);
    date = ApiParse.dateOf(json['activity_date']);
    place = ApiParse.stringOf(json['meeting_point_text']);
    meetingPoint = _coordinates(
      ApiParse.numOf(json['meeting_point_lat']),
      ApiParse.numOf(json['meeting_point_lng']),
    );
    fromTime = ApiParse.timeOf(json['start_time']);
    toTime = ApiParse.timeOf(json['end_time']);
    typeName = ApiParse.stringOf(typeJson['name']);
    kind = ActivityKind.fromApi(typeName ?? ApiParse.stringOf(typeJson['icon']));
  }

  static String? _coordinates(num? lat, num? lng) =>
      lat == null || lng == null ? null : '$lat, $lng';
}

/// Category of an activity. Drives the colour of its rail dot and the chip it
/// maps to in the legend bar at the bottom of the screen.
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

  /// Glyph and label colour.
  final Color color;

  /// Fill behind the glyph, both on the rail and in the legend chip.
  final Color surface;

  static ActivityKind fromSlug(String? slug) => values.firstWhere(
    (kind) => kind.slug == slug,
    orElse: () => ActivityKind.rituals,
  );

  /// Resolves `ActivityTypeResource.name` — free text entered in the back
  /// office rather than one of the three slugs the design draws.
  static ActivityKind fromApi(String? type) {
    final value = type?.toLowerCase().trim() ?? '';
    if (value.isEmpty) return rituals;

    bool has(List<String> words) => words.any(value.contains);

    if (has(['pray', 'salah', 'صلا', 'صلو'])) return prayers;
    if (has(['stay', 'rest', 'hotel', 'sleep', 'إقام', 'اقام', 'راح', 'فندق'])) {
      return stay;
    }
    return rituals;
  }
}
