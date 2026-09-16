import 'package:skygate/core/models/journey_transport.dart';

enum CarrierCategory {
  flights(
    'flights',
    'flights_title',
    'search_airline_hint',
    JourneyTransport.plane,
  ),
  trains(
    'trains',
    'trains_title',
    'search_train_company_hint',
    JourneyTransport.train,
  ),
  seaTransport(
    'sea_transport',
    'sea_transport_title',
    'search_sea_company_hint',
    JourneyTransport.ship,
  ),
  transport(
    'transport',
    'transport_title',
    'search_transport_company_hint',
    JourneyTransport.bus,
  );

  const CarrierCategory(
    this.slug,
    this.titleKey,
    this.searchHintKey,
    this.vehicle,
  );
  final String slug;

  final String titleKey;
  final String searchHintKey;
  final JourneyTransport vehicle;
}

class CarrierModel {
  int? id;
  String? name;
  String? logo;
  String? model;
  int? capacity;

  CarrierModel.fromJson(Map<String, dynamic> json)
    : id = int.tryParse('${json['id']}'),
      logo = json['logo']?.toString(),
      name = json['name']?.toString(),
      model = json['model']?.toString(),
      capacity = int.tryParse('${json['capacity']}');
  bool matches(String query) {
    if (query.isEmpty) return true;
    final needle = query.toLowerCase();
    return [
      name,
      model,
    ].any((field) => field?.toLowerCase().contains(needle) ?? false);
  }

  static List<CarrierModel> catalogueOf(CarrierCategory category) => [
    for (final json in _catalogue[category] ?? const [])
      CarrierModel.fromJson(json),
  ];

  static const Map<CarrierCategory, List<Map<String, dynamic>>> _catalogue = {
    CarrierCategory.flights: [
      {
        'id': 1,
        'name': 'السورية للطيران',
        'model': 'Boeing 737',
        'capacity': 33,
      },
      {
        'id': 2,
        'name': 'الخطوط السعودية',
        'model': 'Airbus A320',
        'capacity': 180,
      },
      {
        'id': 3,
        'name': 'طيران ناس',
        'model': 'Airbus A320neo',
        'capacity': 174,
      },
    ],
    CarrierCategory.trains: [
      {
        'id': 1,
        'name': 'السورية للقطارات',
        'model': 'Talgo 350',
        'capacity': 33,
      },
      {
        'id': 2,
        'name': 'قطار الحرمين السريع',
        'model': 'Talgo 350',
        'capacity': 417,
      },
      {
        'id': 3,
        'name': 'قطار المشاعر المقدسة',
        'model': 'CRRC A2',
        'capacity': 300,
      },
    ],
    CarrierCategory.seaTransport: [
      {'id': 1, 'name': 'سفن جدة', 'model': 'عبّارة سريعة', 'capacity': 33},
      {
        'id': 2,
        'name': 'الجسر العربي للملاحة',
        'model': 'عبّارة ركاب',
        'capacity': 1200,
      },
    ],
    CarrierCategory.transport: [
      {
        'id': 1,
        'name': 'مواصلات جدة',
        'model': 'Mercedes Travego',
        'capacity': 33,
      },
      {
        'id': 2,
        'name': 'النقل الجماعي - سابتكو',
        'model': 'MAN Lion\'s Coach',
        'capacity': 49,
      },
    ],
  };
}
