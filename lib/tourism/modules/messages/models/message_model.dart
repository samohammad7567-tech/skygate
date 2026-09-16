class MessageModel {
  int? id;
  String? message;
  String? sender_type;
  String? receiver_type;
  String? team_id;
  String? sender_id;
  String? receiver_id;
  String? is_read;
  String? attach;
  String? created_at;
  String? updated_at;

  MessageModel({
    this.id,
    this.message,
    this.attach,
    this.sender_type,
    this.receiver_type,
    this.team_id,
    this.sender_id,
    this.receiver_id,
    this.is_read,
    this.created_at,
    this.updated_at,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"] ?? -1,
      message: json["message"] ?? "",
      sender_type: json["sender_type"] ?? "",
      receiver_type: json["receiver_type"] ?? "",
      team_id: json["team_id"] ?? "",
      sender_id: json["sender_id"] ?? "",
      receiver_id: json["receiver_id"] ?? "",
      is_read: json["is_read"] ?? "",
      attach: json["attach"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
