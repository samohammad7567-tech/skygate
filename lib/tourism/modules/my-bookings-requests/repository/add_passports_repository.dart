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

  /// JSON / scan mode:
  /// Sends passports data only (no files) as application/json.
  ///
  /// This matches the "scan passport" scenario and must NOT be
  /// combined with file uploads in the same request.
  Future<Either<Failure, BaseResponse<bool>>> addPassports({
    String? bookingRequestId,
    List<PassportModel>? passports,
  }) async {
    Map<String, dynamic> requestBody = {};

    requestBody["booking_request_id"] = bookingRequestId;

    // Convert passports to the format expected by the backend
    if (passports != null) {
      requestBody["passports"] = passports
          .map((passport) => {
                "first_name": passport.firstName,
                "last_name": passport.lastName,
                "national_number": passport.nationalNumber,
                "date_of_birth": passport.dateOfBirth,
                "passport_number": passport.passportNumber,
                "passport_expiry_date": passport.passportExpiryDate,
                "nationality": passport.nationality,
                "gender": passport.gender,
              })
          .toList();
    }

    try {
      return right(await httpHelper.post(NetworkRoutesControl.addPassports,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody, decoder: (json) {
        if (json != null) {
          return json;
        } else {
          return false;
        }
      }));
    } on Failure catch (e) {
      return left(e);
    }
  }

  /// Files-only mode:
  /// Uploads images / PDF files for passports as multipart/form-data.
  ///
  /// IMPORTANT:
  /// - This MUST NOT be called together with [addPassports] for the same
  ///   operation. The backend expects either JSON (scan) OR files, not both
  ///   in a single request.
  /// - The index of each file in [passportFiles] will be used server-side
  ///   to update the corresponding passport entry by index.
  Future<Either<Failure, BaseResponse<bool>>> uploadPassportFiles({
    String? bookingRequestId,
    required List<File> passportFiles,
  }) async {
    try {
      final fields = <String, String>{
        "booking_request_id": bookingRequestId ?? "",
      };

      final files = <String, List<File>>{
        // Laravel controller expects `passports_files`
        // and will treat multiple uploads under the same
        // field name as an indexed array of files.
        "passports_files[]": passportFiles,
      };

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

  /// Remove passport files from backend by indices or file URLs
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
      return right(await httpHelper.post(NetworkRoutesControl.addPassports,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody, decoder: (json) {
        if (json != null) {
          return json;
        } else {
          return false;
        }
      }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}
