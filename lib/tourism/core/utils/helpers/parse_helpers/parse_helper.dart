import '../../failures/base_failure.dart';
import '../../failures/http/http_failure.dart';

class ParseHelper {
  static String parseFailureToErrorMessage(Failure failure) {
    if (failure is HttpFailure) {
      return parseHttpFailerToErrorMessage(failure);
    } else {
      return 'Unknown error';
    }
  }

  static String parseHttpFailerToErrorMessage(HttpFailure failure) {
    if (failure is NoInternetConnection) {
      return 'There is no internet Connection';
    } else if (failure is UnauthorizedFailure) {
      return 'You need to sign up first';
    } else if (failure is ServerFailure) {
      return 'There is error in the server';
    } else if (failure is TimeOutFailure) {
      return 'request time out, no server response';
    } else if (failure is CustomFailure) {
      return failure.message;
    } else {
      return 'Unknown Http error';
    }
  }
}
