import 'package:skygate/core/constants/home_assets.dart';

/// A card in the "العروض الحالية" carousel.
class OfferModel {
  int? id;
  String? title;
  String? code;
  String? image;

  /// `TravelCategoryModel.id` the offer belongs to — what the pill row filters
  /// the carousel by.
  String? category;

  DateTime? departureDate;
  DateTime? returnDate;
  int? durationDays;
  num? priceFrom;

  /// Raw inclusion slugs (`flight`, `hotel`, `bus`, ...).
  /// Resolve them to bundled glyphs with [OfferInclusion.assetFor].
  List<String> inclusions = const [];

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code']?.toString();
    image = json['image'];
    category = json['category']?.toString();
    departureDate = _parseDate(json['departure_date']);
    returnDate = _parseDate(json['return_date']);
    durationDays = json['duration_days'];
    priceFrom = json['price_from'];
    inclusions = (json['inclusions'] as List?)?.map((e) => '$e').toList() ?? [];
  }

  static DateTime? _parseDate(dynamic value) =>
      value == null ? null : DateTime.tryParse('$value');

  /// Stand-in content for the carousel.
  ///
  /// The pre-booking browse funnel the home screen was built against — the
  /// categories, the priced offers and the services grid — is not in the
  /// OpenAPI document: the nearest published endpoint, `GET app/trips`, lists
  /// only the trips a pilgrim is already booked on, and carries no price, no
  /// cover and no inclusions. So the carousel is fed from here until the
  /// backend publishes `GET offers`.
  ///
  /// Written as the payload that endpoint would answer with, so switching over
  /// is deleting this list and calling it — nothing else in the feature moves.
  /// The first card is the one drawn in the mockup, field for field.
  static final List<OfferModel> catalogue = [
    OfferModel.fromJson({
      'id': 1,
      'title': 'رحلة مكة',
      'code': '201547',
      'category': 'umrah',
      'departure_date': '2026-03-03',
      'return_date': '2026-03-10',
      'duration_days': 7,
      'price_from': 100,
      'inclusions': OfferInclusion.defaultOrder,
    }),
    OfferModel.fromJson({
      'id': 2,
      'title': 'رحلة المدينة المنورة',
      'code': '201548',
      'category': 'umrah',
      'departure_date': '2026-03-12',
      'return_date': '2026-03-18',
      'duration_days': 6,
      'price_from': 85,
      'inclusions': ['flight', 'hotel', 'car', 'accommodation'],
    }),
    OfferModel.fromJson({
      'id': 3,
      'title': 'عمرة رمضان',
      'code': '201549',
      'category': 'umrah',
      'departure_date': '2026-04-05',
      'return_date': '2026-04-15',
      'duration_days': 10,
      'price_from': 150,
      'inclusions': ['flight', 'hotel', 'train', 'accommodation'],
    }),
    OfferModel.fromJson({
      'id': 4,
      'title': 'رحلة جدة الجوية',
      'code': '201550',
      'category': 'flights',
      'departure_date': '2026-05-02',
      'return_date': '2026-05-06',
      'duration_days': 4,
      'price_from': 60,
      'inclusions': ['flight', 'car'],
    }),
    OfferModel.fromJson({
      'id': 5,
      'title': 'إقامة فندقية في مكة',
      'code': '201551',
      'category': 'hotels',
      'departure_date': '2026-05-08',
      'return_date': '2026-05-12',
      'duration_days': 4,
      'price_from': 45,
      'inclusions': ['hotel', 'accommodation'],
    }),
    OfferModel.fromJson({
      'id': 6,
      'title': 'قطار الحرمين السريع',
      'code': '201552',
      'category': 'trains',
      'departure_date': '2026-05-20',
      'return_date': '2026-05-22',
      'duration_days': 2,
      'price_from': 25,
      'inclusions': ['train', 'hotel'],
    }),
    OfferModel.fromJson({
      'id': 7,
      'title': 'رحلة بحرية من جدة',
      'code': '201553',
      'category': 'sea_transport',
      'departure_date': '2026-06-01',
      'return_date': '2026-06-05',
      'duration_days': 4,
      'price_from': 70,
      'inclusions': ['boat', 'hotel'],
    }),
  ];
}

/// Maps inclusion slugs to the small glyphs printed above the offer title.
class OfferInclusion {
  OfferInclusion._();

  static const Map<String, String> _assets = {
    'flight': HomeAssets.flight,
    'hotel': HomeAssets.hotel,
    'train': HomeAssets.train,
    'boat': HomeAssets.seaTransport,
    'car': HomeAssets.car,
    'accommodation': HomeAssets.mosque,
  };

  /// Every glyph, in the order the design prints them.
  static const List<String> defaultOrder = [
    'flight',
    'hotel',
    'train',
    'boat',
    'car',
    'accommodation',
  ];

  static String? assetFor(String slug) => _assets[slug];
}
