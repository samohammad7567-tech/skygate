import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';

enum TimeProgress {
  upcoming(null),
  current('progress_current'),
  finished('progress_finished');

  const TimeProgress(this.labelKey);
  final String? labelKey;

  Color get foreground =>
      this == current ? AppColors.success : AppColors.textSecondary;
  Color get background =>
      this == current ? AppColors.successSurface : AppColors.fieldSurface;
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

  static TimeProgress fromWindow(DateTime? start, DateTime? end) {
    if (start == null && end == null) return upcoming;

    final now = DateTime.now();
    if (end != null && now.isAfter(end)) return finished;
    if (start != null && now.isBefore(start)) return upcoming;
    return current;
  }
}
