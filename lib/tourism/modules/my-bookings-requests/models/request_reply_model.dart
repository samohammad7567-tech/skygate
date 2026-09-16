class RequestReplyModel {
  int? id;
  String? title;
  String? content;
  String? created_at;
  String? updated_at;

  RequestReplyModel({
    this.id,
    this.title,
    this.content,
    this.created_at,
    this.updated_at,
  });

  factory RequestReplyModel.fromJson(Map<String, dynamic> json) {
    return RequestReplyModel(
      id: json["id"] ?? -1,
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
