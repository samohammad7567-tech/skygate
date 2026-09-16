import '../base_failure.dart';

abstract class HttpFailure extends Failure {
  const HttpFailure();
}

class ServerFailure extends HttpFailure {
  const ServerFailure();
}

class CustomFailure extends HttpFailure {
  final String message;

  const CustomFailure({required this.message});
}

class UnauthorizedFailure extends HttpFailure {
  const UnauthorizedFailure();
}

class NoInternetConnection extends HttpFailure {
  const NoInternetConnection();
}

class TimeOutFailure extends HttpFailure {
  const TimeOutFailure();
}

class NotVerifiedFailure extends HttpFailure {
  const NotVerifiedFailure();
}

class UnexpectedResponseFailure extends HttpFailure {
  const UnexpectedResponseFailure();
}

class MethodNotAllowedFailure extends HttpFailure {
  const MethodNotAllowedFailure();
}
