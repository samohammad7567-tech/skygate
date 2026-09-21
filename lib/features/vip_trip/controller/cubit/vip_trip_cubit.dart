import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/hotels/models/hotel_catalogue.dart';

part 'vip_trip_state.dart';

class VipTripCubit extends Cubit<VipTripState> {
  VipTripCubit() : super(VipTripInitial());

  VipTripCubit get(BuildContext context) => BlocProvider.of(context);
  static const int totalSteps = 6;
  int currentStep = 1;

  void goToStep(int step) {
    if (step == currentStep || step < 1 || step > totalSteps) return;
    currentStep = step;
    emit(VipStepChanged());
  }

  final Map<TravelerAudience, int> counts = {
    TravelerAudience.adult: 1,
    TravelerAudience.child: 0,
    TravelerAudience.infant: 0,
  };
  static const int maxPerAudience = 99;

  int countOf(TravelerAudience audience) => counts[audience] ?? 0;
  int get totalTravelers => counts.values.fold(0, (sum, count) => sum + count);
  bool get hasTravelers => countOf(TravelerAudience.adult) > 0;

  void setCount(TravelerAudience audience, int value) {
    final next = value.clamp(0, maxPerAudience);
    if (counts[audience] == next) return;
    counts[audience] = next;
    emit(VipDraftChanged());
  }

  DateTime? startDate;
  DateTime? endDate;
  final Map<BookingCity, int> nights = {
    BookingCity.makkah: 1,
    BookingCity.madinah: 1,
  };

  int nightsIn(BookingCity city) => nights[city] ?? 0;
  DateTime get firstSelectableDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  void setStartDate(DateTime value) {
    startDate = value;
    if (endDate != null && !endDate!.isAfter(value)) endDate = null;
    emit(VipDraftChanged());
  }

  void setEndDate(DateTime value) {
    endDate = value;
    emit(VipDraftChanged());
  }

  void setNights(BookingCity city, int value) {
    final next = value.clamp(0, 99);
    if (nights[city] == next) return;
    nights[city] = next;
    emit(VipDraftChanged());
  }

  int get totalNights => nights.values.fold(0, (sum, count) => sum + count);

  bool get hasDuration =>
      startDate != null && endDate != null && totalNights > 0;
  final Map<GroupRoomType, int> roomCounts = {};
  List<GroupRoomType> get offeredRoomTypes => GroupRoomType.values;

  int roomsOf(GroupRoomType type) => roomCounts[type] ?? 0;
  int get totalRooms => roomCounts.values.fold(0, (sum, count) => sum + count);

  bool get hasRooms => totalRooms > 0;

  /// The distinct room types the traveller picked, as backend ids.
  ///
  /// Walks `GroupRoomType.values` rather than `roomCounts.keys` so the payload
  /// is ordered by room size regardless of the order the picker sheet handed
  /// the counts over. `rooms` carries how many of each; this carries which.
  List<int> get selectedRoomTypeIds => [
    for (final type in GroupRoomType.values)
      if (roomsOf(type) > 0) type.id,
  ];
  void setRoomCounts(Map<GroupRoomType, int> next) {
    roomCounts
      ..clear()
      ..addEntries(next.entries.where((entry) => entry.value > 0));
    emit(VipDraftChanged());
  }

  final Map<BookingCity, List<HotelModel>> _hotels = {};
  final Map<BookingCity, HotelModel> selectedHotels = {};

  List<HotelModel> hotelsIn(BookingCity city) => _hotels[city] ?? const [];

  HotelModel? selectedHotelIn(BookingCity city) => selectedHotels[city];
  Future<void> getHotels(BookingCity city) async {
    emit(VipHotelsLoading());
    try {
      _hotels[city] = [
        for (final hotel in HotelCatalogue.all)
          if (city.matches(hotel.city)) hotel,
      ];
      emit(VipHotelsLoaded());
    } catch (error) {
      debugPrint('getHotels error: $error');
      emit(VipHotelsError(message: ApiError.messageOf(error)));
    }
  }

  void selectHotel(BookingCity city, HotelModel hotel) {
    selectedHotels[city] = hotel;
    emit(VipDraftChanged());
  }

  final TextEditingController requirementsController = TextEditingController();
  static const int maxRequirementsLength = 1000;
  int? requestId;
  Future<void> submit() async {
    emit(VipSubmitLoading());
    try {
      final response = await DioService.post(
        ApiEndpoints.privateTripRequests,
        data: body(),
      );
      final data = response.data['data'];
      print(data);
      requestId = data is Map ? _intOf(data['id']) : null;
      emit(VipSubmitted());
    } catch (error) {
      debugPrint('submitPrivateTripRequest error: $error');
      emit(VipSubmitError(message: ApiError.messageOf(error)));
    }
  }

  Map<String, dynamic> body() {
    final hotelIds = [for (final hotel in selectedHotels.values) ?hotel.id];
    final roomTypeIds = selectedRoomTypeIds;

    return <String, dynamic>{
      'people_count': totalTravelers,
      'adult_count': countOf(TravelerAudience.adult),
      'child_count': countOf(TravelerAudience.child),
      'infant_count': countOf(TravelerAudience.infant),
      'preferred_start_date': _date(startDate),
      'preferred_end_date': _date(endDate),
      if (hotelIds.isNotEmpty) 'hotel_ids': hotelIds,
      'requirements': _requirements(),
      'makkah_nights_count': nightsIn(BookingCity.makkah),
      'madinah_nights_count': nightsIn(BookingCity.madinah),
      if (roomTypeIds.isNotEmpty) 'room_type_ids': roomTypeIds,
      'rooms': [
        for (final entry in roomCounts.entries)
          {'room_type': entry.key.slug, 'count': entry.value},
      ],
    }..removeWhere((_, value) => value == null);
  }

  String _requirements() {
    final typed = requirementsController.text.trim();
    final lines = [
      if (typed.isNotEmpty) typed,
      for (final entry in roomCounts.entries)
        '${entry.key.slug} x${entry.value}',
      for (final entry in selectedHotels.entries)
        '${entry.key.slug}: ${entry.value.name ?? entry.value.id}',
    ];

    final text = lines.join('\n');
    return text.length <= maxRequirementsLength
        ? text
        : text.substring(0, maxRequirementsLength);
  }

  static String? _date(DateTime? value) =>
      value?.toIso8601String().split('T').first;

  static int? _intOf(dynamic value) =>
      value is int ? value : int.tryParse('${value ?? ''}');

  @override
  Future<void> close() {
    requirementsController.dispose();
    return super.close();
  }
}
