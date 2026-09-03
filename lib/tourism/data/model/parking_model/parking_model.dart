class ParkingModel {
  String? parkingCode;
  bool? isReserved;
  String? parkingPrice;

  ParkingModel({this.parkingCode, this.isReserved, this.parkingPrice});

  Map<String, dynamic> toMap() {
    return {
      'parkingCode': this.parkingCode,
      'isReserved': this.isReserved,
      'parkingPrice' : this.parkingPrice,
    };
  }

  factory ParkingModel.fromMap(Map<String, dynamic> map) {
    return ParkingModel(
      parkingCode: map['parking_code'] as String,
      isReserved: map['is_reserved'] as bool,
        parkingPrice: map['parking_price'] as String,
    );
  }
}