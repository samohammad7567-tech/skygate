import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/payment_assets.dart';

/// The three tabs of "رحلاتي".
///
/// Each one is a server-side filter rather than a client-side grouping: the
/// screen asks `app/my-trips?filter[status]=<filter>` and renders whatever
/// comes back, so the tab a trip lands in is the API's call, not the app's.
enum TripsTab {
  current('current', 'trips_tab_current', PaymentAssets.calendar),
  upcoming('upcoming', 'trips_tab_upcoming', PaymentAssets.upcoming),
  past('past', 'trips_tab_completed', PaymentAssets.done);

  const TripsTab(this.filter, this.labelKey, this.icon);

  /// Value sent as `filter[status]`. Required by the endpoint.
  final String filter;

  final String labelKey;
  final String icon;

  /// The chip printed over a card's photo repeats the tab, because the tab is
  /// what the API already decided about the trip.
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

  /// Reads `filter_status` back off a trip. The API puts each trip in one of
  /// the three buckets itself, so the badge on a card repeats its answer
  /// instead of repeating the tab being viewed — the two can disagree for a
  /// trip that started between the request and the render.
  static TripsTab? fromApi(String? value) {
    final label = value?.toLowerCase().trim() ?? '';
    if (label.isEmpty) return null;

    bool has(List<String> words) => words.any(label.contains);

    if (has(['past', 'complet', 'finish', 'done', 'منته', 'سابق'])) return past;
    if (has(['upcoming', 'future', 'next', 'قادم'])) return upcoming;
    if (has(['current', 'ongoing', 'active', 'running', 'حالي']))
      return current;
    return null;
  }

  /// Shown when the tab comes back empty — each one reads differently.
  String get emptyKey => switch (this) {
    TripsTab.current => 'no_current_trips',
    TripsTab.upcoming => 'no_upcoming_trips',
    TripsTab.past => 'no_past_trips',
  };
}
