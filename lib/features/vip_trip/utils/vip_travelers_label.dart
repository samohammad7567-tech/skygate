import 'package:easy_localization/easy_localization.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';

String vipTravelersLabel(Map<TravelerAudience, int> counts) {
  final parts = [
    for (final audience in TravelerAudience.values)
      if ((counts[audience] ?? 0) > 0)
        '${counts[audience]} ${audience.countLabelKey.tr()}',
  ];
  return parts.isEmpty ? '—' : parts.join(' - ');
}

String vipRequestTravelersLabel(PrivateTripRequestModel request) =>
    vipTravelersLabel({
      TravelerAudience.adult: request.adultCount ?? 0,
      TravelerAudience.child: request.childCount ?? 0,
      TravelerAudience.infant: request.infantCount ?? 0,
    });
