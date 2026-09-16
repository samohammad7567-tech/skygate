class TravelAllowedCountryModel {
  int? id;
  String? country;
  String? visa_needed;
  String? flag;
  String? created_at;
  String? updated_at;

  TravelAllowedCountryModel({
    this.id,
    this.country,
    this.visa_needed,
    this.flag,
    this.created_at,
    this.updated_at,
  });

  factory TravelAllowedCountryModel.fromJson(Map<String, dynamic> json) {
    return TravelAllowedCountryModel(
      id: json['id'] as int?,
      country: json['country'] as String?,
      visa_needed: json['visa_needed'] as String?,
      flag: json['flag'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'visa_needed': visa_needed,
      'flag': flag,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
