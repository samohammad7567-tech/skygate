class LocalLanguageModel {
  String locale;

  LocalLanguageModel(this.locale);

  factory LocalLanguageModel.fromJson(json) {
    return LocalLanguageModel(json["locale"]);
  }

  Map<String,String> toJson() => {"locale": locale};
}
