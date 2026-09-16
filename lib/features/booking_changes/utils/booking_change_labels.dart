import 'package:easy_localization/easy_localization.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';

String bookingChangeTypeLabel(BookingChangeRequestModel request) {
  if (request.isKnownType) return request.type.labelKey.tr();

  final sent = request.typeLabel?.trim();
  if (sent != null && sent.isNotEmpty) return sent;

  return BookingChangeType.other.labelKey.tr();
}
