import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/http_helper.dart';
import 'package:skygate/tourism/data/model/base_response/base_response.dart';
import 'package:skygate/tourism/data/shared/shared_class.dart';
import 'package:skygate/tourism/modules/edit_profile/params/edit_profile_params.dart';
import 'package:skygate/tourism/modules/language/language_controller.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import '../../../core/utils/constants/constants.dart';

class EditProfileRepository {
  late LanguageController languageController;
  late HttpHelper httpHelper;

  EditProfileRepository() {
    languageController = Get.find<LanguageController>();
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<UserModel>>> editUserProfile({
    required EditProfileParams params,
    required File? avatar_image,
  }) async {
    try {
      String baseUrl = NetworkRoutesControl.updateAccount;

      var postUri = Uri.parse(baseUrl);
      var request = http.MultipartRequest("POST", postUri);
      request.headers['Authorization'] = 'Bearer ${SharedClass.apiToken}';
      request.fields['password'] = params.password!;
      request.fields['user_id'] = SharedClass.userId;

      if (avatar_image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'avatar',
            await avatar_image.readAsBytes(),
            filename: "avatar",
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      if (params.national_id_images!.isNotEmpty) {
        for (final element in params.national_id_images!) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'national_id_images',
              await element.readAsBytes(),
              filename: "national_id_images",
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      if (params.passport_images!.isNotEmpty) {
        for (final element in params.passport_images!) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'passport_images',
              await element.readAsBytes(),
              filename: "passport_images",
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      log("Request for $baseUrl");
      log("+with request body fields ${request.fields}");
      log("+with request headers ${request.headers}");
      log("+with request body files ${request.files}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final resultEncoded = jsonDecode(response.body) as Map<String, dynamic>;
      final result = BaseResponse.fromJson(
        resultEncoded,
        (json) => UserModel.fromJSON(json),
      );
      log("+with response code ${result.code}");
      log("+with response message ${result.message}");
      log("+with response data ${result.data}");

      return right(result);
    } on Failure catch (e) {
      return left(e);
    }
  }
}
