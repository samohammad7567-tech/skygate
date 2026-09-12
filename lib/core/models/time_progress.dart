import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';

/// Where something on the programme sits against the clock.
///
/// The day schedule chips its activities with this and "مسار الرحلة" chips
/// its legs with it — the same three standings, drawn the same way — so the
/// enum is shared rather than written out per feature.
enum TimeProgress {
  upcoming(null),
  current('progress_current'),
  finished('progress_finished');

  const TimeProgress(this.labelKey);

  /// Null on the one standing the design leaves unchipped.
  final String? labelKey;

  Color get foreground =>
      this == current ? AppColors.success : AppColors.textSecondary;
  Color get background =>
      this == current ? AppColors.successSurface : AppColors.fieldSurface;

  /// Reads whatever the API labelled a row with. `status` is an array of
  /// undocumented strings on every resource that carries one.
  static TimeProgress fromApi(String? value) {
    final label = value?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return upcoming;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['finish', 'complet', 'ended', 'done', 'منته', 'انته'])) {
      return finished;
    }
    if (has(['current', 'ongoing', 'active', 'running', 'الحالي', 'جاري'])) {
      return current;
    }
    return upcoming;
  }

  /// Works it out from the window itself, for the rows the API gives times
  /// but no standing — which is every leg of the route.
  static TimeProgress fromWindow(DateTime? start, DateTime? end) {
    if (start == null && end == null) return upcoming;

    final now = DateTime.now();
    if (end != null && now.isAfter(end)) return finished;
    if (start != null && now.isBefore(start)) return upcoming;
    return current;
  }
}
