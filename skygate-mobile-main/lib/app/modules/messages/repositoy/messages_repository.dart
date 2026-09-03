import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/messages/models/message_model.dart';

class MessagesRepository {
  late HttpHelper httpHelper;

  MessagesRepository() {
    httpHelper = Get.find<HttpHelper>();
  }

  Future<Either<Failure, BaseResponse<bool>>> sendMessage({String? msg, String? targetTeam, File? attach=null}) async {
    String baseUrl = NetworkRoutesControl.createMessage;

    var postUri = Uri.parse(baseUrl);
    var request = http.MultipartRequest("POST", postUri);
    request.headers['Authorization'] = 'Bearer ${SharedClass.apiToken}';
    request.fields['sender_id'] = SharedClass.userId;
    request.fields['receiver_id'] = '';
    request.fields['message'] = msg!;
    request.fields['team_id'] = targetTeam!;

    if (attach != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'attach',
        await attach.readAsBytes(),
        filename: "attach",
      ));
    }
    try {
      log("Request for ${baseUrl}");
      log("+with request body fields ${request.fields}");
      log("+with request headers ${request.headers}");
      log("+with request body files ${request.files}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final resultEncoded = jsonDecode(response.body) as Map<String, dynamic>;
      final result = BaseResponse.fromJson(resultEncoded, (json) {
          if(json != null) {
            return json as bool;
          } else {
            return false;
          }
      });
      log("+with response code ${result.code}");
      log("+with response message ${result.message}");
      log("+with response data ${result.data}");
      return right(result);
    } on Failure catch (e) {
      return left(e);
    }
  }

  Future<Either<Failure, BaseResponse<List<MessageModel>>>> getMessages({String? targetTeam}) async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    requestBody["team_id"] = targetTeam;
    try {
      return right(await httpHelper.post(NetworkRoutesControl.getAllMessages, headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken), body: requestBody, decoder: (json) {
        if (json != null) {
          return json.map<MessageModel>((json) => MessageModel.fromJson(json)).toList();
        } else {
          return [];
        }
      }));
    } on Failure catch (e) {
      return left(e);
    }
  }
}
