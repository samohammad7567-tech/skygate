import 'package:dartz/dartz.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/base_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/http_helper.dart';
import 'package:sky_gate/app/data/model/base_response/base_response.dart';
import 'package:sky_gate/app/data/shared/shared_class.dart';
import 'package:sky_gate/app/modules/notifications/models/notification_model.dart';

class NotificationsRepository {
  late HttpHelper httpHelper;

  NotificationsRepository() {
    httpHelper = HttpHelper();
  }

  Future<Either<Failure, BaseResponse<List<NotificationModel>>>> getUserNotifications() async {
    Map<String, dynamic> requestBody = {};
    requestBody["user_id"] = SharedClass.userId;
    try {
      return right(await httpHelper.post(
          NetworkRoutesControl.getUserNotifications,
          headers: HttpHelper.basicHeaderWithToken(SharedClass.apiToken),
          body: requestBody,
          decoder: (json) {
            if(json != null) {
              return json.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
            } else {
              return [];
            }

          }));
    } on Failure catch (e) {
      return left(e);
    }
  }

}
