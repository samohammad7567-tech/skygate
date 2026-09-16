import 'package:skygate/tourism/core/utils/failures/field_failure/field_failure.dart';

class CustomFieldFailure extends FieldFailure {
  final String message;

  const CustomFieldFailure({required this.message});
}
