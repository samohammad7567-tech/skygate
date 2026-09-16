import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/sos/models/chat_message_model.dart';

part 'support_chat_state.dart';

class SupportChatCubit extends Cubit<SupportChatState> {
  SupportChatCubit() : super(SupportChatInitial());

  SupportChatCubit get(BuildContext context) => BlocProvider.of(context);
  TripChatModel? chat;
  List<ChatMessageModel> messages = [];
  bool isLoadingMore = false;
  bool hasMorePages = true;
  final TextEditingController composer = TextEditingController();

  bool get isOnline => chat?.isOpen ?? false;
  Future<void> openChat() async {
    emit(SupportChatLoading());
    try {
      await _readThread();
      await _readMessages();
      emit(SupportChatLoaded());
      await markRead();
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
      final before = messages.first.id;
      final older = await _fetch(beforeId: before);
      hasMorePages = older.isNotEmpty;
      messages = [...older, ...messages];
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
    final lastId = messages.isEmpty ? null : messages.last.id;
    if (lastId == null) return;

    try {
      await DioService.post(
        ApiEndpoints.tripChatRead,
        data: {'last_read_message_id': lastId},
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
    messages = await _fetch();
    hasMorePages = messages.isNotEmpty;
  }

  Future<List<ChatMessageModel>> _fetch({int? beforeId}) async {
    final response = await DioService.get(
      ApiEndpoints.tripChatMessages,
      queryParameters: beforeId == null ? null : {'before_id': beforeId},
    );
    return ApiParse.rowsOf(response.data['data'], ChatMessageModel.fromJson);
  }

  @override
  Future<void> close() {
    composer.dispose();
    return super.close();
  }
}
