class FAQsModel {
  String? question;
  String? answer;

  FAQsModel({this.question, this.answer});

  factory FAQsModel.fromJSON(Map<String, dynamic> json) {
    return FAQsModel(
      question: json['question'] ?? "",
      answer: json['answer'] ?? "",
    );
  }
}
