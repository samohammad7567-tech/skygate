class CreditCardModel {
  String? balance;
  String? card_number;
  String? cvc;
  String? expiry_date;
  String? pin;

  CreditCardModel({
    this.balance,
    this.card_number,
    this.cvc,
    this.expiry_date,
    this.pin,
  });

  factory CreditCardModel.fromJSON(Map<String, dynamic> json) {
    return CreditCardModel(
      balance: json['balance'] ?? "",
      card_number: json['card_number'] ?? "",
      cvc: json['cvc'] ?? "",
      expiry_date: json['expiry_date'] ?? "",
      pin: json['pin'] ?? "",
    );
  }
}
