
import '../base_failure.dart';

abstract class LocalStorageFailure extends Failure{
  const LocalStorageFailure();
}

class DataNotExist extends LocalStorageFailure{
  const DataNotExist();
}