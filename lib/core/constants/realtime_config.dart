/// Laravel Reverb connection settings and channel names.
///
/// Reverb speaks the Pusher protocol but runs on our own host, so the values
/// come from the backend's `REVERB_*` environment. Supply them at build time,
/// the same way `API_HOST` is supplied:
///
/// ```
/// flutter run \
///   --dart-define=REVERB_APP_KEY=... \
///   --dart-define=REVERB_HOST=dev.skygate.site \
///   --dart-define=REVERB_PORT=443 \
///   --dart-define=REVERB_SCHEME=https
/// ```
///
/// With no key supplied the app stays on REST alone: [isConfigured] is false
/// and nothing ever opens a socket.
class RealtimeConfig {
  RealtimeConfig._();

  static const String appKey = String.fromEnvironment('REVERB_APP_KEY');
  static const String host = String.fromEnvironment(
    'REVERB_HOST',
    defaultValue: 'dev.skygate.site',
  );
  static const int port = int.fromEnvironment('REVERB_PORT', defaultValue: 443);
  static const String scheme = String.fromEnvironment(
    'REVERB_SCHEME',
    defaultValue: 'https',
  );

  static bool get isConfigured => appKey.isNotEmpty;
  static bool get isSecure => scheme == 'https' || scheme == 'wss';

  /// Where Laravel signs our private/presence subscriptions. Sits at the web
  /// root, not under `/api/v1/`.
  static String get authEndpoint =>
      '${isSecure ? 'https' : 'http'}://$host/broadcasting/auth';

  /// Pusher protocol 7 handshake URL.
  static Uri get socketUri => Uri.parse(
    '${isSecure ? 'wss' : 'ws'}://$host:$port/app/$appKey'
    '?protocol=7&client=dart&version=1.0',
  );

  /// Laravel declares these channels without a prefix, but the Pusher protocol
  /// requires one. A missing prefix fails the subscription silently — no
  /// exception, no error, just messages that never arrive.
  static String chatChannel(int tripId) => 'presence-trip.$tripId.chat';
  static String leaderChannel(int tripId) => 'private-trip.$tripId.leader';

  /// `private-trip.{id}.locations` carries every pilgrim's coordinates and is
  /// refused for anyone but the leader and admins. The app never asks for it —
  /// the refusal is the correct behaviour, not a bug to work around.

  /// Plain event names. The leading dot seen in Laravel Echo examples is an
  /// Echo convention for "no namespace" and must not be sent on the wire.
  static const String chatMessageEvent = 'chat.message';
  static const String locationUpdatedEvent = 'location.updated';
}
