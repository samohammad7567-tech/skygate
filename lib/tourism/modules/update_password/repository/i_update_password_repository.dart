import 'package:dartz/dartz.dart';
import 'package:skygate/tourism/modules/user/user_model.dart';
import '../../../core/utils/failures/base_failure.dart';
import '../../../data/model/base_response/base_response.dart';
import '../../../data/model/sign_in/sign_in_model.dart';
import '../../../data/model/update_password/update_password.dart';

abstract class IUpdatePasswordRepository {
  Future<Either<Failure, BaseResponse>> updatePassword(UpdatePasswordModel model);
  Future<Either<Failure, BaseResponse<UserModel>>> signIn(SignInModel model);
}
