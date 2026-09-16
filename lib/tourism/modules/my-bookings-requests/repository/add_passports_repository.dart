import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/passport_model.dart';

class AddPassportsRepository {
  late HttpHelper httpHelper;

  AddPassportsRepository() {
    httpHelper = Get.find<HttpHelper>();
  }
  Future<Either<Failure, BaseResponse<bool>>> addPassports({
    String? bookingRequestId,
    List<PassportModel>? passports,
  }) async {
    Map<String, dynamic> requestBody = {};

    requestBody["booking_request_id"] = bookingRequestId;
    if (passports != null) {
      requestBody["passports"] = passports
          .map(
            (passport) => {
              "first_name": passport.firstName,
              "last_name": passport.lastName,
              "national_number": passport.nationalNumber,
              "date_of_birth": passport.dateOfBirth,
              "passport_number": passport.passportNumber,
              "passport_expiry_date": passport.passportExpiryDate,
              "nationality": passport.nationality,
              "gender": passport.gender,
            },
          )
          .toList();
    }

    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.addPassports,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return json;
            } else {
              return false;
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<bool>>> uploadPassportFiles({
    String? bookingRequestId,
    required List<File> passportFiles,
  }) async {
    try {
      final fields = <String, String>{
        "booking_request_id": bookingRequestId ?? "",
      };

      final files = <String, List<File>>{"passports_files[]": passportFiles};

      final response = await httpHelper.postMultipart<bool>(
        NetworkRoutesControl.addPassports,
        headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
        fields: fields,
        files: files,
        decoder: (json) {
          if (json != null) {
            return json;
          } else {
            return false;
          }
        },
      );

      return right(response);
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<bool>>> removePassportFiles({
    String? bookingRequestId,
    List<int>? deletedIndices,
    List<String>? removedFileUrls,
  }) async {
    Map<String, dynamic> requestBody = {};

    requestBody["booking_request_id"] = bookingRequestId;

    if (deletedIndices != null && deletedIndices.isNotEmpty) {
      requestBody["deleted_indices"] = deletedIndices;
    }

    if (removedFileUrls != null && removedFileUrls.isNotEmpty) {
      requestBody["removed_file_urls"] = removedFileUrls;
    }

    try {
      return right(
        await httpHelper.post(
          NetworkRoutesControl.addPassports,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if (json != null) {
              return json;
            } else {
              return false;
            }
          },
        ),
      );
    } on Failure catch (e) {
      return left(e);
    }
  }
}
