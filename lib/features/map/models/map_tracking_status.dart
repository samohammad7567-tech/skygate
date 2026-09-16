enum MapTrackingStatus {
  loading,

  /// No booking, or the trip has not reached `started` yet.
  inactive,

  /// Location permission or the tracking protocol is still outstanding.
  consent,

  /// Trip is `started` — pings are flowing.
  active,

  /// Pings have gone quiet for longer than the server tolerates.
  disconnected,

  /// Trip is `almost-done`: the server refuses pings, but the chat stays open.
  wrappingUp,

  /// Trip is `completed` or `cancelled`.
  finished;

  /// The server's `umrah.gps_ping_timeout_minutes` is 3 minutes, and a job runs
  /// every minute flagging anyone quieter than that as a lost signal. 60
  /// seconds leaves a threefold margin without draining the battery.
  static const Duration pingEvery = Duration(seconds: 60);

  /// Matches the server's tolerance, so the pilgrim sees the warning at the
  /// same moment the leader is told the signal was lost.
  static const Duration staleAfter = Duration(minutes: 3);

  /// Safe areas are not broadcast — moving a circle raises no socket event —
  /// so they are re-read every few ping ticks instead.
  static const int safeAreaEveryTicks = 3;
}
