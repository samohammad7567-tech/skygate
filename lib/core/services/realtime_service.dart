import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:skygate/core/constants/realtime_config.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/pusher_socket.dart';

/// Live trip updates over Laravel Reverb.
///
/// A pilgrim listens on exactly two channels:
///   * `presence-trip.{id}.chat`  — new group messages
///   * `private-trip.{id}.leader` — the trip leader's location
///
/// `private-trip.{id}.locations` carries every pilgrim's coordinates and is
/// refused to anyone but the leader and admins. The app never asks for it.
///
/// Static, to match [DioService] and `LocationService`: one socket is shared by
/// the map and the chat rather than each opening its own.
class RealtimeService {
  RealtimeService._();

  static PusherSocket? _socket;
  static StreamSubscription<PusherFrame>? _frames;
  static StreamSubscription<PusherState>? _states;
  static bool _hasConnected = false;

  static final StreamController<Map<String, dynamic>> _messages =
      StreamController.broadcast();
  static final StreamController<Map<String, dynamic>> _leaderMoves =
      StreamController.broadcast();
  static final StreamController<void> _reconnects =
      StreamController.broadcast();

  /// New `chat.message` payloads. Unlike the REST reply these carry no
  /// `is_mine` — compare `sender_pilgrim_id` against your own id yourself.
  static Stream<Map<String, dynamic>> get messages => _messages.stream;

  /// `location.updated` payloads for the trip leader only.
  static Stream<Map<String, dynamic>> get leaderMoves => _leaderMoves.stream;

  /// Fires after the socket comes back from a drop. The socket replays
  /// nothing, so listeners must refetch over REST and merge by id.
  static Stream<void> get reconnects => _reconnects.stream;

  static bool get isAvailable => RealtimeConfig.isConfigured;
  static bool get isConnected => _socket?.isConnected ?? false;

  static Future<void> joinChat(int tripId) =>
      _join(RealtimeConfig.chatChannel(tripId));

  static Future<void> leaveChat(int tripId) =>
      _leave(RealtimeConfig.chatChannel(tripId));

  static Future<void> joinLeader(int tripId) =>
      _join(RealtimeConfig.leaderChannel(tripId));

  static Future<void> leaveLeader(int tripId) =>
      _leave(RealtimeConfig.leaderChannel(tripId));

  /// Closes the socket outright — call on logout.
  static Future<void> shutdown() async {
    await _frames?.cancel();
    _frames = null;
    await _states?.cancel();
    _states = null;
    await _socket?.close();
    _socket = null;
    _hasConnected = false;
  }

  static Future<void> _join(String channel) async {
    if (!isAvailable) return;
    await _ensure().subscribe(channel);
  }

  static Future<void> _leave(String channel) async {
    await _socket?.unsubscribe(channel);
  }

  static PusherSocket _ensure() {
    final existing = _socket;
    if (existing != null) return existing;

    final socket = PusherSocket(
      uri: RealtimeConfig.socketUri,
      authorize: _authorize,
    );
    _socket = socket;
    _frames = socket.frames.listen(_onFrame);
    _states = socket.states.listen(_onState);
    return socket;
  }

  static void _onFrame(PusherFrame frame) {
    switch (frame.name) {
      case RealtimeConfig.chatMessageEvent:
        if (!_messages.isClosed) _messages.add(frame.payload);
      case RealtimeConfig.locationUpdatedEvent:
        // The leader channel should only ever carry the leader, but the flag
        // is authoritative — trust it rather than the channel name.
        if (frame.payload['is_leader'] == true && !_leaderMoves.isClosed) {
          _leaderMoves.add(frame.payload);
        }
    }
  }

  static void _onState(PusherState state) {
    if (state != PusherState.connected) return;

    // The first connection has nothing to catch up on; later ones do.
    if (_hasConnected && !_reconnects.isClosed) _reconnects.add(null);
    _hasConnected = true;
  }

  /// Signs a channel with Laravel. Goes through [DioService] so the auth
  /// interceptor attaches the bearer token — without it the subscription is
  /// refused and no message ever arrives, with nothing logged anywhere else.
  static Future<Map<String, dynamic>> _authorize(
    String channel,
    String socketId,
  ) async {
    final response = await DioService.dio.post<dynamic>(
      RealtimeConfig.authEndpoint,
      data: {'socket_id': socketId, 'channel_name': channel},
    );

    final body = response.data;
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return body.map((key, value) => MapEntry('$key', value));

    debugPrint('Broadcast auth returned an unexpected body for $channel');
    return const <String, dynamic>{};
  }
}
