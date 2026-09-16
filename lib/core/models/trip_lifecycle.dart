import 'package:skygate/core/utils/api_parse.dart';

/// The trip's server-side lifecycle, read from `booking.trip.status`.
///
/// Tracking and chat are two separate gates, not one. Location pings and the
/// live location channels are accepted only while the trip is exactly
/// [started]; the chat opens at the same moment but stays open through
/// [almostDone], and closes only once the trip is [completed] or [cancelled].
enum TripLifecycle {
  draft,
  published,
  registrationClosed,
  inProcess,
  started,
  almostDone,
  completed,
  cancelled,
  unknown;

  static TripLifecycle fromApi(dynamic value) {
    final label = ApiParse.labelOf(
      value,
    )?.toLowerCase().trim().replaceAll(RegExp(r'[\s_]+'), '-');

    return switch (label) {
      'draft' => draft,
      'published' => published,
      'registration-closed' => registrationClosed,
      'in-process' => inProcess,
      'started' => started,
      'almost-done' => almostDone,
      'completed' => completed,
      'cancelled' || 'canceled' => cancelled,
      _ => unknown,
    };
  }

  /// Location pings and the live location channels require exactly `started`.
  /// In `almost-done` the server answers pings with 400 — by design.
  bool get allowsTracking => this == started;

  /// The group chat spans `started` and `almost-done`.
  bool get allowsChat => this == started || this == almostDone;

  /// The trip is over for good — tear both features down.
  bool get isOver => this == completed || this == cancelled;
}
