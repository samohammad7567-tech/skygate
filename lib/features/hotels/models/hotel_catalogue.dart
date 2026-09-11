import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/hotel_model.dart';

class HotelCatalogue {
  HotelCatalogue._();

  static List<HotelModel> get all => [
    HotelModel.local(
      id: 1,
      name: 'فندق مكة',
      city: 'مكة المكرمة',
      rating: 4.0,
      nights: 4,
      address: 'شارع الملك فيصل الطريق الأول ، مكة',
      checkIn: DateTime(2026, 8, 18),
      checkOut: DateTime(2026, 8, 22),
      latitude: 21.422,
      longitude: 39.826,
      rooms: const [GroupRoomType.quad, GroupRoomType.quint],
    ),
    HotelModel.local(
      id: 2,
      name: 'فندق إطلالة مكة الفاخر',
      city: 'مكة المكرمة',
      rating: 4.5,
      nights: 4,
      address: 'شارع الملك فيصل الطريق الأول ، مكة',
      checkIn: DateTime(2026, 8, 18),
      checkOut: DateTime(2026, 8, 22),
      latitude: 21.418,
      longitude: 39.824,
      rooms: const [GroupRoomType.twin, GroupRoomType.quad],
    ),
    HotelModel.local(
      id: 3,
      name: 'فندق دار الإيمان',
      city: 'المدينة المنورة',
      rating: 5.0,
      nights: 3,
      address: 'المنطقة المركزية ، المدينة المنورة',
      checkIn: DateTime(2026, 8, 22),
      checkOut: DateTime(2026, 8, 25),
      latitude: 24.468,
      longitude: 39.611,
      rooms: const [
        GroupRoomType.single,
        GroupRoomType.twin,
        GroupRoomType.triple,
      ],
    ),
    HotelModel.local(
      id: 4,
      name: 'فندق أنوار المدينة',
      city: 'المدينة المنورة',
      rating: 3.5,
      nights: 3,
      address: 'طريق الملك عبدالعزيز ، المدينة المنورة',
      checkIn: DateTime(2026, 8, 22),
      checkOut: DateTime(2026, 8, 25),
      latitude: 24.471,
      longitude: 39.614,
      rooms: const [GroupRoomType.triple, GroupRoomType.sextuple],
    ),
  ];
}
