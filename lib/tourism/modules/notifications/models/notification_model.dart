class NotificationModel {
  int? id;
  String? user_id;
  String? content;
  String? created_at;
  String? updated_at;

  NotificationModel({
    this.id,
    this.user_id,
    this.content,
    this.created_at,
    this.updated_at,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"] ?? "",
      user_id: json["user_id"] ?? "",
      content: json["content"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
