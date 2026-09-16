enum MapTrackingStatus {
  loading,
  inactive,
  consent,
  active,
  disconnected,
  finished;

  static const Duration staleAfter = Duration(minutes: 15);
}
