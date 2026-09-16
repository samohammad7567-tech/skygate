class PaymentMethodModel {
  int? id;
  String? title;
  String? subtitle;
  String? details;
  String? image;
  String? created_at;
  String? updated_at;

  PaymentMethodModel({
    this.id,
    this.title,
    this.subtitle,
    this.details,
    this.image,
    this.created_at,
    this.updated_at,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json["id"] ?? -1,
      title: json["title"] ?? "",
      subtitle: json["subtitle"] ?? "",
      details: json["details"] ?? "",
      image: json["image"] ?? "",
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
