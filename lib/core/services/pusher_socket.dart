import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

enum PusherState { disconnected, connecting, connected }

/// One application frame received on a channel.
@immutable
class PusherFrame {
  const PusherFrame({
    required this.channel,
    required this.name,
    required this.payload,
  });

  final String channel;
  final String name;
  final Map<String, dynamic> payload;
}

/// The slice of the Pusher protocol (v7) this app actually needs: open a
/// socket, sign a private/presence channel, subscribe, receive events, stay
/// alive, and come back after a drop.
///
/// Client-triggered events and encrypted channels are deliberately missing —
/// the pilgrim app only ever listens. Written against `web_socket_channel`
/// because `pusher_channels_flutter` cannot address a self-hosted Reverb host:
/// its `init()` takes a Pusher `cluster` and no host or port.
class PusherSocket {
  PusherSocket({required this.uri, required this.authorize});

  final Uri uri;

  /// Signs a channel subscription — in practice a POST to
  /// `/broadcasting/auth`, whose body is `{auth: "key:signature"}` plus
  /// `channel_data` for presence channels.
  final Future<Map<String, dynamic>> Function(String channel, String socketId)
  authorize;

  static const Duration _pingEvery = Duration(seconds: 30);
  static const Duration _pongWithin = Duration(seconds: 10);
  static const int _backoffFloorSeconds = 2;
  static const int _backoffCeilingSeconds = 60;

  final StreamController<PusherFrame> _frames = StreamController.broadcast();
  final StreamController<PusherState> _states = StreamController.broadcast();

  Stream<PusherFrame> get frames => _frames.stream;

  /// Connection state. Every transition to [PusherState.connected] after the
  /// first is a reconnection, and a reconnection means a gap: the socket never
  /// replays what it missed, so listeners must refetch over REST.
  Stream<PusherState> get states => _states.stream;

  /// Channels we want to be on. Resubscribed from scratch on every reconnect,
  /// because the server remembers nothing about us.
  final Set<String> _wanted = {};
  final Set<String> _live = {};

  WebSocketChannel? _socket;
  StreamSubscription<dynamic>? _listener;
  Timer? _ping;
  Timer? _pong;
  Timer? _retry;
  String? _socketId;
  int _attempt = 0;
  bool _closing = false;
  PusherState _state = PusherState.disconnected;

  PusherState get state => _state;
  bool get isConnected => _state == PusherState.connected;

  Future<void> subscribe(String channel) async {
    if (!_wanted.add(channel)) return;
    if (isConnected) {
      await _subscribe(channel);
    } else {
      await connect();
    }
  }

  Future<void> unsubscribe(String channel) async {
    _wanted.remove(channel);
    if (!_live.remove(channel) || !isConnected) return;
    _send({
      'event': 'pusher:unsubscribe',
      'data': {'channel': channel},
    });
  }

  Future<void> connect() async {
    if (_closing || _state != PusherState.disconnected) return;
    _set(PusherState.connecting);

    try {
      final socket = WebSocketChannel.connect(uri);
      _socket = socket;
      await socket.ready;
      _listener = socket.stream.listen(
        _onFrame,
        onError: _onBreak,
        onDone: _onBreak,
        cancelOnError: true,
      );
    } catch (error) {
      _onBreak(error);
    }
  }

  /// Drops the connection and forgets every channel. Safe to call twice.
  Future<void> close() async {
    _closing = true;
    _retry?.cancel();
    _retry = null;
    _wanted.clear();
    _attempt = 0;
    _teardown();
    _set(PusherState.disconnected);
    _closing = false;
  }

  void _onFrame(dynamic frame) {
    final envelope = _mapOf(frame);
    final name = envelope?['event']?.toString();
    if (envelope == null || name == null) return;

    // `data` arrives as a JSON *string*, not an object — decode it again.
    final payload = _mapOf(envelope['data']) ?? const <String, dynamic>{};
    final channel = envelope['channel']?.toString();

    switch (name) {
      case 'pusher:connection_established':
        _onEstablished(payload);
      case 'pusher:ping':
        _send({'event': 'pusher:pong', 'data': <String, dynamic>{}});
      case 'pusher:pong':
        _pong?.cancel();
        _pong = null;
      case 'pusher:error':
        debugPrint('Pusher error [${payload['code']}]: ${payload['message']}');
      case 'pusher_internal:subscription_succeeded':
        if (channel != null) _live.add(channel);
      default:
        if (name.startsWith('pusher:') || name.startsWith('pusher_internal:')) {
          return;
        }
        if (channel == null || _frames.isClosed) return;
        _frames.add(
          PusherFrame(channel: channel, name: name, payload: payload),
        );
    }
  }

  void _onEstablished(Map<String, dynamic> payload) {
    _socketId = payload['socket_id']?.toString();
    _attempt = 0;
    _set(PusherState.connected);
    _startPinging();
    for (final channel in _wanted.toList()) {
      unawaited(_subscribe(channel));
    }
  }

  Future<void> _subscribe(String channel) async {
    final socketId = _socketId;
    if (socketId == null || !isConnected) return;

    final body = <String, dynamic>{'channel': channel};

    if (channel.startsWith('private-') || channel.startsWith('presence-')) {
      try {
        final signed = await authorize(channel, socketId);
        final auth = signed['auth']?.toString();
        if (auth == null || auth.isEmpty) {
          // Worth shouting about: an unsigned subscribe is discarded by the
          // server in silence, and the only symptom is messages never arriving.
          debugPrint('Pusher auth returned no signature for $channel');
          return;
        }
        body['auth'] = auth;

        final members = signed['channel_data'];
        if (members != null) {
          body['channel_data'] = members is String
              ? members
              : jsonEncode(members);
        }
      } catch (error) {
        debugPrint('Pusher auth failed for $channel: $error');
        return;
      }
    }

    if (!isConnected) return;
    _send({'event': 'pusher:subscribe', 'data': body});
  }

  void _startPinging() {
    _ping?.cancel();
    _ping = Timer.periodic(_pingEvery, (_) {
      if (!isConnected) return;
      _send({'event': 'pusher:ping', 'data': <String, dynamic>{}});
      _pong?.cancel();
      _pong = Timer(_pongWithin, () {
        debugPrint('Pusher pong timed out — reconnecting');
        _onBreak();
      });
    });
  }

  void _onBreak([Object? error]) {
    if (error != null) debugPrint('PusherSocket dropped: $error');
    _teardown();
    if (_closing) return;
    _set(PusherState.disconnected);
    _scheduleRetry();
  }

  void _teardown() {
    _ping?.cancel();
    _ping = null;
    _pong?.cancel();
    _pong = null;
    unawaited(_listener?.cancel());
    _listener = null;
    _socketId = null;
    _live.clear();
    try {
      _socket?.sink.close(ws_status.normalClosure);
    } catch (error) {
      debugPrint('PusherSocket.close error: $error');
    }
    _socket = null;
  }

  void _scheduleRetry() {
    if (_wanted.isEmpty || _retry != null) return;

    final seconds = (_backoffFloorSeconds << _attempt.clamp(0, 5)).clamp(
      _backoffFloorSeconds,
      _backoffCeilingSeconds,
    );
    _attempt++;
    _retry = Timer(Duration(seconds: seconds), () {
      _retry = null;
      unawaited(connect());
    });
  }

  void _send(Map<String, dynamic> frame) {
    try {
      _socket?.sink.add(jsonEncode(frame));
    } catch (error) {
      debugPrint('PusherSocket.send error: $error');
    }
  }

  void _set(PusherState next) {
    if (_state == next) return;
    _state = next;
    if (!_states.isClosed) _states.add(next);
  }

  static Map<String, dynamic>? _mapOf(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry('$key', item));
    }

    final text = value?.toString();
    if (text == null || text.isEmpty) return null;

    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((key, item) => MapEntry('$key', item));
      }
    } catch (error) {
      debugPrint('PusherSocket decode error: $error');
    }
    return null;
  }
}
