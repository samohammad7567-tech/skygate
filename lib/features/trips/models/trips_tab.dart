import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/payment_assets.dart';

enum TripsTab {
  current('current', 'trips_tab_current', PaymentAssets.calendar),
  upcoming('upcoming', 'trips_tab_upcoming', PaymentAssets.upcoming),
  past('past', 'trips_tab_completed', PaymentAssets.done);

  const TripsTab(this.filter, this.labelKey, this.icon);
  final String filter;

  final String labelKey;
  final String icon;
  Color get foreground => switch (this) {
    TripsTab.current => AppColors.primary,
    TripsTab.upcoming => AppColors.accent,
    TripsTab.past => AppColors.success,
  };

  Color get background => switch (this) {
    TripsTab.current => AppColors.surfaceTint,
    TripsTab.upcoming => AppColors.accentSurface,
    TripsTab.past => AppColors.successSurface,
  };
  static TripsTab? fromApi(String? value) {
    final label = value?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return null;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['past', 'complet', 'finish', 'done', 'منته', 'سابق'])) return past;
    if (has(['upcoming', 'future', 'next', 'قادم'])) return upcoming;
    if (has(['current', 'ongoing', 'active', 'running', 'حالي'])) {
      return current;
    }
    return null;
  }

  String get emptyKey => switch (this) {
    TripsTab.current => 'no_current_trips',
    TripsTab.upcoming => 'no_upcoming_trips',
    TripsTab.past => 'no_past_trips',
  };
}
