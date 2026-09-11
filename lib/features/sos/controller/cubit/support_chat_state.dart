part of 'support_chat_cubit.dart';

@immutable
sealed class SupportChatState {}

final class SupportChatInitial extends SupportChatState {}

final class SupportChatLoading extends SupportChatState {}

final class SupportChatLoadingMore extends SupportChatState {}

final class SupportChatLoaded extends SupportChatState {}

final class SupportChatError extends SupportChatState {
  SupportChatError({required this.message});

  final String message;
}
