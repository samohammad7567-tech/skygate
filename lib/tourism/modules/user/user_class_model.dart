class UserClassModel {
  int? id;
  String? name_en;
  String? name_ar;
  String? related_edu_stage;
  String? edu_stage_en;
  String? edu_stage_ar;
  int? students_number;
  String? created_at;
  String? updated_at;

  UserClassModel({
    this.id,
    this.name_en,
    this.name_ar,
    this.related_edu_stage,
    this.edu_stage_en,
    this.edu_stage_ar,
    this.students_number,
    this.created_at,
    this.updated_at,
  });

  factory UserClassModel.fromJSON(Map<String, dynamic> json) {
    return UserClassModel(
      id: json["id"] ?? -1,
      name_en: json["name_en"] ?? "",
      name_ar: json["name_ar"] ?? "",
      related_edu_stage: json["related_edu_stage"] ?? "",
      edu_stage_en: json["edu_stage_en"] ?? "",
      edu_stage_ar: json["edu_stage_ar"] ?? "",
      students_number: json["students_number"] ?? 0,
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJSON({required UserClassModel model}) {
    Map<String, dynamic> json = {};
    json["id"] = model.id;
    json["name_en"] = model.name_en;
    json["name_ar"] = model.name_ar;
    json["related_edu_stage"] = model.related_edu_stage;
    json["edu_stage_en"] = model.edu_stage_en;
    json["edu_stage_ar"] = model.edu_stage_ar;
    json["students_number"] = model.students_number;
    json["created_at"] = model.created_at;
    json["updated_at"] = model.updated_at;

    return json;
  }
}
