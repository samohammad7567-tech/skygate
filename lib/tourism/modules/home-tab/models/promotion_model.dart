class PromotionModel {
  String? image;
  String? from;
  String? to;
  String? description;
  String? currency;
  String? cost;
  int? id;

  PromotionModel({this.id, this.image, this.from, this.to, this.description,this.currency, this.cost});

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
        image : json["image"]?? "",
        id : json["id"]?? -1,
        from : json["from"]?? "",
        to : json["to"]?? "",
        description : json["description"]?? "",
        cost : json["cost"]?? "",
        currency : json["currency"]?? ""
    );
  }
}