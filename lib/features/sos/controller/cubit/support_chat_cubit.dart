import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/realtime_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/auth/controller/cubit/auth_cubit.dart';
import 'package:skygate/features/sos/models/chat_message_model.dart';

part 'support_chat_state.dart';

/// The trip group chat.
///
/// Its gate is not the tracking gate: the chat opens when the trip starts and
/// stays open through `almost-done`, closing only at `completed` or
/// `cancelled`. `GET app/trip-chat` answers 404 once it is closed, which makes
/// it the authoritative signal here — no separate status lookup needed.
class SupportChatCubit extends Cubit<SupportChatState> {
  SupportChatCubit() : super(SupportChatInitial());

  SupportChatCubit get(BuildContext context) => BlocProvider.of(context);

  static const int _pageSize = 50;

  TripChatModel? chat;
  List<ChatMessageModel> messages = [];
  bool isLoadingMore = false;
  bool hasMorePages = false;
  int? myPilgrimId;
  final TextEditingController composer = TextEditingController();

  int? _nextBeforeId;
  final Set<int> _seenIds = {};
  StreamSubscription<Map<String, dynamic>>? _incoming;
  StreamSubscription<void>? _reconnects;

  bool get isOnline => chat?.isOpen ?? false;

  Future<void> openChat() async {
    emit(SupportChatLoading());
    try {
      await _readThread();
      await _readMessages();
      _resolveOwnership();
      emit(SupportChatLoaded());
      await Future.wait([markRead(), _listen()]);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        // The trip finished or was cancelled and the thread is gone for good.
        debugPrint('openChat: thread closed');
        emit(SupportChatClosed());
        return;
      }
      debugPrint('openChat error: $error');
      emit(SupportChatError(message: ApiError.messageOf(error)));
    } catch (error) {
      debugPrint('openChat error: $error');
      emit(SupportChatError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> loadOlder() async {
    if (isLoadingMore || !hasMorePages || messages.isEmpty) return;

    isLoadingMore = true;
    emit(SupportChatLoadingMore());

    try {
      final page = await _fetch(beforeId: _nextBeforeId ?? messages.first.id);
      hasMorePages = page.hasMore;
      _nextBeforeId = page.nextBeforeId;
      _merge(page.messages);
      emit(SupportChatLoaded());
    } catch (error) {
      debugPrint('loadOlder error: $error');
      emit(SupportChatError(message: ApiError.messageOf(error)));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> send() async {
    final text = composer.text.trim();
    if (text.isEmpty) return;

    final pending = ChatMessageModel.pending(text);
    messages = [...messages, pending];
    composer.clear();
    emit(SupportChatLoaded());

    try {
      final response = await DioService.post(
        ApiEndpoints.tripChatMessages,
        data: ChatMessageModel.sendBody(text),
      );
      final body = response.data['data'];
      final sent = body is Map<String, dynamic>
          ? ChatMessageModel.fromJson(body)
          : null;

      // The socket may already have echoed this message back to us; record the
      // id so the echo is dropped rather than shown twice.
      final id = sent?.id;
      if (id != null) _seenIds.add(id);

      messages = [
        for (final message in messages)
          if (identical(message, pending))
            sent ?? (pending..isPending = false)
          else
            message,
      ];
      emit(SupportChatLoaded());
    } catch (error) {
      debugPrint('send error: $error');
      messages = [
        for (final message in messages)
          if (!identical(message, pending)) message,
      ];
      composer.text = text;
      emit(SupportChatError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> markRead() async {
    try {
      final lastId = _lastServerId;
      await DioService.post(
        ApiEndpoints.tripChatRead,
        // The thread may legitimately be empty — clear the badge either way.
        data: lastId == null ? null : {'last_read_message_id': lastId},
      );
      chat?.unreadCount = 0;
    } catch (error) {
      debugPrint('markRead error: $error');
    }
  }

  Future<void> _readThread() async {
    final response = await DioService.get(ApiEndpoints.tripChat);
    final body = response.data['data'];
    chat = body is Map<String, dynamic> ? TripChatModel.fromJson(body) : null;
  }

  Future<void> _readMessages() async {
    final page = await _fetch();
    hasMorePages = page.hasMore;
    _nextBeforeId = page.nextBeforeId;
    _merge(page.messages);
  }

  /// Our own pilgrim id, needed because socket payloads carry no `is_mine`
  /// the way REST replies do. Cached at login; if that is somehow missing,
  /// history tells us — the server already flagged our own messages.
  void _resolveOwnership() {
    myPilgrimId ??= CacheUtil.get(key: AuthCubit.pilgrimIdKey) as int?;
    myPilgrimId ??= messages
        .where((message) => message.isMine && message.senderPilgrimId != null)
        .firstOrNull
        ?.senderPilgrimId;

    for (final message in messages) {
      message.resolveMine(myPilgrimId);
    }
  }

  Future<TripChatPage> _fetch({int? beforeId}) async {
    final response = await DioService.get(
      ApiEndpoints.tripChatMessages,
      queryParameters: {'limit': _pageSize, 'before_id': ?beforeId},
    );
    return TripChatPage.fromJson(response.data['data']);
  }

  Future<void> _listen() async {
    final tripId = chat?.tripId;
    if (tripId == null || !RealtimeService.isAvailable) return;

    _incoming ??= RealtimeService.messages.listen(_onIncoming);

    // The socket never replays what arrived while we were disconnected, so the
    // only way to close that gap is to refetch and merge by id.
    _reconnects ??= RealtimeService.reconnects.listen((_) {
      unawaited(_catchUp());
    });

    await RealtimeService.joinChat(tripId);
  }

  void _onIncoming(Map<String, dynamic> payload) {
    if (isClosed) return;

    final tripId = chat?.tripId;
    if (tripId != null && ApiParse.intOf(payload['trip_id']) != tripId) return;

    final message = ChatMessageModel.fromJson(payload)
      ..resolveMine(myPilgrimId);
    if (!_merge([message])) return;

    emit(SupportChatLoaded());
    unawaited(markRead());
  }

  Future<void> _catchUp() async {
    try {
      final page = await _fetch();
      if (isClosed || !_merge(page.messages)) return;
      emit(SupportChatLoaded());
    } catch (error) {
      debugPrint('_catchUp error: $error');
    }
  }

  /// Adds whatever is genuinely new and keeps the thread ordered oldest first.
  ///
  /// Merging on `id` and not `sent_at`: a message can arrive twice — once from
  /// the socket, once from a refetch — and two messages can share a second.
  bool _merge(List<ChatMessageModel> incoming) {
    final fresh = <ChatMessageModel>[];
    for (final message in incoming) {
      final id = message.id;
      if (id == null || !_seenIds.add(id)) continue;
      message.resolveMine(myPilgrimId);
      fresh.add(message);
    }
    if (fresh.isEmpty) return false;

    messages = [...messages, ...fresh]
      ..sort((a, b) => (a.id ?? _big).compareTo(b.id ?? _big));
    return true;
  }

  /// Pending messages have no id yet and belong at the end of the thread.
  static const int _big = 1 << 52;

  int? get _lastServerId {
    for (final message in messages.reversed) {
      final id = message.id;
      if (id != null) return id;
    }
    return null;
  }

  @override
  Future<void> close() async {
    await _incoming?.cancel();
    await _reconnects?.cancel();
    final tripId = chat?.tripId;
    if (tripId != null) await RealtimeService.leaveChat(tripId);
    composer.dispose();
    return super.close();
  }
}
