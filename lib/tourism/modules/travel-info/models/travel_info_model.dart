class TravelInfoModel {
  int? id;
  String? title;
  String? details;
  String? created_at;
  String? updated_at;

  TravelInfoModel({
    this.id,
    this.title,
    this.details,
    this.created_at,
    this.updated_at,
  });

  factory TravelInfoModel.fromJson(Map<String, dynamic> json) {
    return TravelInfoModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      details: json['details'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
