import 'package:easy_localization/easy_localization.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';

/// How a request's type reads on screen.
///
/// A code this build knows is translated; anything the back office added
/// since keeps the wording the API sent, which is already localized by the
/// `X-localization` header. The generic key is the last resort.
String bookingChangeTypeLabel(BookingChangeRequestModel request) {
  if (request.isKnownType) return request.type.labelKey.tr();

  final sent = request.typeLabel?.trim();
  if (sent != null && sent.isNotEmpty) return sent;

  return BookingChangeType.other.labelKey.tr();
}
