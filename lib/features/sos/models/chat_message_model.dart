import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/utils/api_parse.dart';

class TripChatModel {
  int? id;
  int? tripId;
  String? status;
  DateTime? openedAt;
  int? participantsCount;
  int unreadCount = 0;
  DateTime? lastReadAt;

  TripChatModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    tripId = ApiParse.intOf(json['trip_id']);
    status = ApiParse.labelOf(json['status']);
    openedAt = ApiParse.dateOf(json['opened_at']);
    participantsCount = ApiParse.intOf(json['participants_count']);
    unreadCount = ApiParse.intOf(json['unread_count']) ?? 0;
    lastReadAt = ApiParse.dateOf(json['last_read_at']);
  }
  bool get isOpen {
    final label = status?.toLowerCase() ?? '';
    if (label.isEmpty) return openedAt != null;
    return !['closed', 'archived', 'مغلق', 'مؤرشف'].any(label.contains);
  }
}

class ChatMessageModel {
  int? id;
  int? chatId;
  int? senderPilgrimId;
  String? senderName;
  bool isMine = false;

  String? body;
  String? attachmentUrl;
  DateTime? sentAt;

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    chatId = ApiParse.intOf(json['trip_chat_id']);
    senderPilgrimId = ApiParse.intOf(json['sender_pilgrim_id']);
    senderName = ApiParse.stringOf(json['sender_name']);
    isMine = ApiParse.boolOf(json['is_mine'], orElse: false);
    body = ApiParse.stringOf(json['body'] ?? json['message']);
    attachmentUrl = ApiParse.stringOf(json['attachment_url']);
    sentAt = ApiParse.dateOf(json['sent_at'] ?? json['created_at']);
  }
  ChatMessageModel.pending(String text) {
    body = text;
    isMine = true;
    sentAt = DateTime.now();
    isPending = true;
  }
  bool isPending = false;

  String? get attachment => ApiEndpoints.mediaUrl(attachmentUrl);
  static Map<String, dynamic> sendBody(String text, {String? attachmentUrl}) =>
      <String, dynamic>{
        'body': text,
        'message': text,
        'attachment_url': ?attachmentUrl,
      };
}
