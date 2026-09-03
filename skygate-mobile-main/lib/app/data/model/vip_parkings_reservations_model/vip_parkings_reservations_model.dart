class VipParkingsReservationsModel {
  String? parkerID;
  String? parkingCode;
  String? parkingEndDateTime;
  String? parkingStartDateTime;
  String? totalParkingFee;

  VipParkingsReservationsModel(
      {this.parkerID,
      this.parkingCode,
      this.parkingEndDateTime,
      this.parkingStartDateTime,
      this.totalParkingFee});


  factory VipParkingsReservationsModel.fromJSON(Map<String, dynamic> json) {
    return VipParkingsReservationsModel(
        parkerID : json["parkerID"] ?? "",
        parkingCode : json["parkingCode"] ?? "",
        parkingEndDateTime : json["parkingEndDateTime"] ?? "",
        parkingStartDateTime : json["parkingStartDateTime"] ?? "",
        totalParkingFee : json["totalParkingFee"] ?? ""
    );
  }
}