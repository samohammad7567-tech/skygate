import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/core/models/booking_type.dart';

class BookingOptionModel {
  const BookingOptionModel({
    required this.type,
    required this.titleKey,
    required this.descKey,
    required this.icon,
    required this.criteriaKeys,
  });

  final BookingType type;
  final String titleKey;
  final String descKey;
  final String icon;
  final List<String> criteriaKeys;

  static const List<BookingOptionModel> catalogue = [
    BookingOptionModel(
      type: BookingType.individual,
      titleKey: 'booking_individual_only',
      descKey: 'booking_individual_desc',
      icon: AuthAssets.accountCircle,
      criteriaKeys: [
        'booking_individual_criteria_1',
        'booking_individual_criteria_2',
      ],
    ),
    BookingOptionModel(
      type: BookingType.group,
      titleKey: 'booking_group_family',
      descKey: 'booking_group_desc',
      icon: JourneyAssets.supervisors,
      criteriaKeys: [
        'booking_group_criteria_1',
        'booking_group_criteria_2',
        'booking_group_criteria_3',
      ],
    ),
  ];
}
