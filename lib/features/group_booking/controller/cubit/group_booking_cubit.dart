import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/models/passport_form.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/models/booking_route_model.dart';
import 'package:skygate/features/group_booking/models/group_room_allocation.dart';
import 'package:skygate/features/group_booking/models/group_room_model.dart';
import 'package:skygate/features/group_booking/models/group_room_price_model.dart';
import 'package:skygate/features/group_booking/models/group_room_seat.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/features/group_booking/models/group_traveler_model.dart';
import 'package:skygate/core/models/traveler_audience.dart';

part 'group_booking_state.dart';

class GroupBookingCubit extends Cubit<GroupBookingState> {
  GroupBookingCubit(this.tripId) : super(GroupBookingInitial());

  GroupBookingCubit get(BuildContext context) => BlocProvider.of(context);
  final int tripId;
  TripModel? trip;
  String? get tripTitle => trip?.title;

  Future<TripModel> _loadTrip({bool refresh = false}) async {
    final loaded = await TripService.trip(tripId, refresh: refresh);
    trip = loaded;
    return loaded;
  }

  static const int totalSteps = 9;
  static const int paymentWindowHours = 24;
  int currentStep = 1;

  void goToStep(int step) {
    if (step == currentStep || step < 1 || step > totalSteps) return;
    currentStep = step;
    emit(GroupStepChanged());
  }

  // ── Steps 2 & 4 — the traveller being added ──────────────────────────────
  final PassportForm passportForm = PassportForm();

  final List<UmrahDocumentModel> documentTypes = UmrahDocumentModel.catalogue;
  final Map<String, File> documents = {};
  int? draftGuardianId;

  bool get isScanned => passportForm.isScanned;

  bool get pledgeAccepted => passportForm.pledgeAccepted;
  bool get isAddingLeader => travelers.isEmpty;
  TravelerAudience get draftAudience =>
      TravelerAudience.fromBirthDate(passportForm.birthDate);
  void startNewTraveler() {
    passportForm.clear();
    documents.clear();
    draftGuardianId = null;
    emit(GroupPassportFieldChanged());
  }

  void passportChanged() => emit(GroupPassportFieldChanged());

  void togglePledge(bool? value) {
    passportForm.pledgeAccepted = value ?? false;
    emit(GroupPassportFieldChanged());
  }

  void selectGuardian(int? localId) {
    draftGuardianId = localId;
    emit(GroupPassportFieldChanged());
  }

  Future<void> scanPassportFrom(ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) {
      emit(GroupPassportScanCancelled());
      return;
    }
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(GroupFileTooLarge());
      return;
    }
    await scanPassport(file);
  }

  Future<void> scanPassport(File image) async {
    emit(GroupPassportScanLoading());
    return DioService.post(
          ApiEndpoints.scanPassport,
          data: FormData.fromMap({
            'passport_image': await MultipartFile.fromFile(image.path),
          }),
        )
        .then((response) {
          final body = response.data['data'];
          passportForm.fillFrom(
            PassportDataModel.fromJson(
              body is Map<String, dynamic> ? body : const {},
            ),
          );
          passportForm.isScanned = true;
          emit(GroupPassportScanned());
        })
        .catchError((error) {
          debugPrint('scanPassport error: $error');
          emit(GroupPassportScanError(message: ApiError.messageOf(error)));
        });
  }

  void resetScan() {
    passportForm.resetScan();
    emit(GroupPassportFieldChanged());
  }

  Future<void> pickDocument(String id, ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) return;
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(GroupFileTooLarge());
      return;
    }
    documents[id] = file;
    emit(GroupDocumentPicked());
  }

  void removeDocument(String id) {
    documents.remove(id);
    emit(GroupDocumentPicked());
  }

  // ── Steps 3 & 5 — the group ──────────────────────────────────────────────
  final List<GroupTravelerModel> travelers = [];

  int _nextLocalId = 1;
  GroupTravelerModel? get leader => travelers.isEmpty ? null : travelers.first;
  List<GroupTravelerModel> get adults => travelers
      .where((traveler) => traveler.audience == TravelerAudience.adult)
      .toList();

  int countOf(TravelerAudience audience) =>
      travelers.where((traveler) => traveler.audience == audience).length;

  GroupTravelerModel? travelerOf(int? localId) {
    if (localId == null) return null;
    for (final traveler in travelers) {
      if (traveler.localId == localId) return traveler;
    }
    return null;
  }

  bool get isGroupComplete => travelers.length >= 2;
  void commitTraveler() {
    travelers.add(
      GroupTravelerModel(
        localId: _nextLocalId++,
        passport: passportForm.toModel(),
        documents: Map<String, File>.from(documents),
        guardianLocalId: travelers.isEmpty ? null : draftGuardianId,
      ),
    );
    passportForm.clear();
    documents.clear();
    draftGuardianId = null;
    emit(GroupTravelersChanged());
  }

  void removeTraveler(int localId) {
    final leaving = [
      localId,
      ...travelers
          .where((traveler) => traveler.guardianLocalId == localId)
          .map((traveler) => traveler.localId),
    ];

    for (final id in leaving) {
      travelers.removeWhere((traveler) => traveler.localId == id);
      for (final room in rooms) {
        room.travelerIds.remove(id);
      }
    }
    emit(GroupTravelersChanged());
  }

  // ── Step 6 — route ───────────────────────────────────────────────────────
  List<BookingRouteModel> routes = [];
  int selectedRouteIndex = 0;

  BookingRouteModel? get selectedRoute =>
      selectedRouteIndex < routes.length ? routes[selectedRouteIndex] : null;

  void selectRoute(int index) {
    if (selectedRouteIndex == index) return;
    selectedRouteIndex = index;
    emit(GroupRoutesLoaded());
  }

  Future<void> getRoutes() async {
    emit(GroupRoutesLoading());
    try {
      final loaded = await _loadTrip();
      routes = loaded.itinerary.isEmpty
          ? []
          : [BookingRouteModel.fromTrip(loaded)];
      if (selectedRouteIndex >= routes.length) selectedRouteIndex = 0;
      emit(GroupRoutesLoaded());
    } catch (error) {
      debugPrint('getRoutes error: $error');
      emit(GroupRoutesError(message: ApiError.messageOf(error)));
    }
  }

  // ── Step 7 — rooms ───────────────────────────────────────────────────────
  final Map<GroupRoomType, GroupRoomPriceModel> roomPrices = {};
  final List<GroupRoomModel> rooms = [];

  GroupRoomPriceModel? priceOf(GroupRoomType type) => roomPrices[type];
  List<GroupRoomType> get offeredRoomTypes =>
      GroupRoomType.values.where(roomPrices.containsKey).toList();
  Future<void> getRoomPrices() async {
    emit(GroupRoomPricesLoading());
    try {
      final loaded = await _loadTrip();
      roomPrices.clear();
      for (final package in loaded.packages) {
        final price = GroupRoomPriceModel.fromPackage(package);
        roomPrices.putIfAbsent(price.type, () => price);
      }
      emit(GroupRoomPricesLoaded());
    } catch (error) {
      debugPrint('getRoomPrices error: $error');
      emit(GroupRoomPricesError(message: ApiError.messageOf(error)));
    }
  }

  Map<GroupRoomType, int> get roomCounts {
    final counts = <GroupRoomType, int>{};
    for (final room in rooms) {
      counts[room.type] = (counts[room.type] ?? 0) + 1;
    }
    return counts;
  }

  void setRoomCounts(Map<GroupRoomType, int> counts) {
    for (final type in GroupRoomType.values) {
      final wanted = counts[type] ?? 0;
      final current = rooms.where((room) => room.type == type).toList();

      for (var i = current.length; i > wanted; i--) {
        rooms.remove(current[i - 1]);
      }
      for (var i = current.length; i < wanted; i++) {
        rooms.add(GroupRoomModel(type: type, price: roomPrices[type]));
      }
    }
    _pruneAllocations();
    emit(GroupRoomsChanged());
  }

  void removeRoom(int index) {
    if (index < 0 || index >= rooms.length) return;
    rooms.removeAt(index);
    _pruneAllocations();
    emit(GroupRoomsChanged());
  }

  void assignTravelers(int index, List<int> travelerIds) {
    if (index < 0 || index >= rooms.length) return;
    final room = rooms[index];
    final seated = travelerIds.take(room.capacity).toList();

    for (var i = 0; i < rooms.length; i++) {
      if (i == index) continue;
      rooms[i].travelerIds.removeWhere(seated.contains);
    }
    room.travelerIds
      ..clear()
      ..addAll(seated);
    if (room.lockedBeds > room.freeBeds) room.lockedBeds = room.freeBeds;
    emit(GroupRoomsChanged());
  }

  void lockSpareBeds(int index) {
    if (index < 0 || index >= rooms.length) return;
    rooms[index].lockedBeds = rooms[index].freeBeds;
    emit(GroupRoomsChanged());
  }

  List<GroupTravelerModel> travelersFor(int roomIndex) {
    final room = roomIndex < rooms.length ? rooms[roomIndex] : null;
    final seatedElsewhere = <int>{
      for (var i = 0; i < rooms.length; i++)
        if (i != roomIndex) ...rooms[i].travelerIds,
    };

    return travelers
        .where(
          (traveler) =>
              !seatedElsewhere.contains(traveler.localId) ||
              (room?.travelerIds.contains(traveler.localId) ?? false),
        )
        .toList();
  }

  List<TravelerAudience> audiencesIn(GroupRoomModel room) => [
    for (final id in room.travelerIds)
      travelerOf(id)?.audience ?? TravelerAudience.adult,
  ];
  List<GroupRoomSeat> seatsOf(GroupRoomModel room) {
    final prices = room.travelerPrices(audiencesIn(room));

    return [
      for (var i = 0; i < room.travelerIds.length; i++)
        if (travelerOf(room.travelerIds[i]) case final traveler?)
          (
            traveler: traveler,
            price: prices[i],
            isSecondInfant: isSecondInfant(
              room.travelerIds,
              room.travelerIds[i],
            ),
          ),
    ];
  }

  Map<TravelerAudience, int> countsIn(GroupRoomModel room) {
    final audiences = audiencesIn(room);

    return {
      for (final audience in TravelerAudience.values)
        audience: audiences.where((value) => value == audience).length,
    };
  }

  num totalOf(GroupRoomModel room) => room.total(audiencesIn(room));
  num priceIn(GroupRoomType type, List<int> selected, int localId) {
    final sheet = roomPrices[type];
    final audience = travelerOf(localId)?.audience;
    if (sheet == null || audience == null) return 0;

    return sheet.priceOf(
      audience,
      isSecondInfant: isSecondInfant(selected, localId),
    );
  }

  bool isSecondInfant(List<int> selected, int localId) {
    if (travelerOf(localId)?.audience != TravelerAudience.infant) return false;

    return selected
        .takeWhile((id) => id != localId)
        .any((id) => travelerOf(id)?.audience == TravelerAudience.infant);
  }

  bool get areRoomsSettled =>
      rooms.isNotEmpty &&
      rooms.every((room) => room.isSettled) &&
      travelers.every(
        (traveler) =>
            rooms.any((room) => room.travelerIds.contains(traveler.localId)),
      );

  // ── Step 8 — the rooms of each city, spread over its hotels ──────────────
  final Map<BookingCity, List<HotelModel>> hotels = {};
  final Map<BookingCity, int> stayDays = {};
  final Map<BookingCity, Map<int, GroupRoomAllocation>> allocations = {};

  List<HotelModel> hotelsIn(BookingCity city) => hotels[city] ?? const [];

  GroupRoomAllocation allocationOf(BookingCity city, int? hotelId) =>
      allocations[city]?[hotelId ?? -1] ?? GroupRoomAllocation();
  int allocatedIn(BookingCity city) =>
      (allocations[city]?.values ?? const <GroupRoomAllocation>[]).fold(
        0,
        (sum, allocation) => sum + allocation.total,
      );
  bool isCityAllocated(BookingCity city) =>
      rooms.isNotEmpty && allocatedIn(city) == rooms.length;
  Map<GroupRoomType, int> availableIn(BookingCity city, int? hotelId) {
    final byHotel = allocations[city] ?? const <int, GroupRoomAllocation>{};

    return {
      for (final entry in roomCounts.entries)
        entry.key:
            entry.value -
            byHotel.entries
                .where((hotel) => hotel.key != hotelId)
                .fold(0, (sum, hotel) => sum + hotel.value.of(entry.key)),
    };
  }

  void allocateRooms(
    BookingCity city,
    int hotelId,
    Map<GroupRoomType, int> counts,
  ) {
    final byHotel = allocations.putIfAbsent(city, () => {});
    byHotel.putIfAbsent(hotelId, GroupRoomAllocation.new).replaceWith(counts);
    byHotel.removeWhere((_, allocation) => allocation.isEmpty);
    emit(GroupHotelsLoaded());
  }

  Future<void> getHotels(BookingCity city) async {
    emit(GroupHotelsLoading());
    try {
      final loaded = await _loadTrip();
      final inCity = [
        for (final hotel in loaded.hotels)
          if (city.matches(hotel.city)) hotel,
      ];

      hotels[city] = [
        for (final hotel in inCity) HotelModel.fromTripHotel(hotel),
      ];
      stayDays[city] = inCity.fold(
        0,
        (sum, hotel) => sum + (hotel.nights ?? 0),
      );
      emit(GroupHotelsLoaded());
    } catch (error) {
      debugPrint('getHotels ${city.slug} error: $error');
      emit(GroupHotelsError(message: ApiError.messageOf(error)));
    }
  }

  HotelModel? hotelFor(BookingCity city, int roomIndex) {
    if (roomIndex >= rooms.length) return null;
    final type = rooms[roomIndex].type;
    var position = rooms
        .take(roomIndex)
        .where((room) => room.type == type)
        .length;

    for (final hotel in hotelsIn(city)) {
      final taken = allocationOf(city, hotel.id).of(type);
      if (position < taken) return hotel;
      position -= taken;
    }
    return null;
  }

  void _pruneAllocations() {
    final booked = roomCounts;

    for (final byHotel in allocations.values) {
      for (final type in GroupRoomType.values) {
        var left = booked[type] ?? 0;

        for (final allocation in byHotel.values) {
          final take = allocation.of(type) < left ? allocation.of(type) : left;
          if (take == 0) {
            allocation.counts.remove(type);
          } else {
            allocation.counts[type] = take;
          }
          left -= take;
        }
      }
      byHotel.removeWhere((_, allocation) => allocation.isEmpty);
    }
  }

  // ── Step 9 — summary ─────────────────────────────────────────────────────
  DateTime? paymentDeadline;
  Duration remaining = Duration.zero;

  Timer? _countdown;
  num get grandTotal => rooms.fold<num>(0, (sum, room) => sum + totalOf(room));
  String? get currency {
    for (final room in rooms) {
      if (room.currency != null) return room.currency;
    }
    return null;
  }

  void prepareSummary() {
    emit(GroupSummaryLoading());
    paymentDeadline = DateTime.now().add(
      const Duration(hours: paymentWindowHours),
    );
    _startCountdown();
    emit(GroupSummaryLoaded());
  }

  void _startCountdown() {
    _countdown?.cancel();
    remaining = _timeLeft();
    if (remaining == Duration.zero) return;

    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = _timeLeft();
      if (remaining == Duration.zero) timer.cancel();
      emit(GroupCountdownTicked());
    });
  }

  Duration _timeLeft() {
    final expiry = paymentDeadline;
    if (expiry == null) return Duration.zero;
    final left = expiry.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  // ── Submit ───────────────────────────────────────────────────────────────
  Future<void> submit() async {
    emit(GroupSubmitLoading());
    try {
      await _createPilgrims();
      await DioService.post(ApiEndpoints.bookings, data: bookingBody());
      await _uploadDocuments();
      emit(GroupSubmitted());
    } catch (error) {
      debugPrint('submit group booking error: $error');
      emit(GroupSubmitError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> _createPilgrims() async {
    for (final traveler in travelers) {
      if (traveler.pilgrimId != null) continue;

      // A plain Map, so Dio posts JSON. Wrapping it in a [FormData] would
      // stringify `is_self` and `guardian_pilgrim_id` and get them rejected —
      // see [PassportDataModel.toPilgrimJson].
      final response = await DioService.post(
        ApiEndpoints.pilgrims,
        data: traveler.toPilgrimJson(
          isSelf: traveler == leader,
          guardianPilgrimId: travelerOf(traveler.guardianLocalId)?.pilgrimId,
        ),
      );
      final created = response.data['data'];
      traveler.pilgrimId = created is Map ? created['id'] as int? : null;
    }
  }

  int? packageIdOf(GroupRoomType type) => roomPrices[type]?.packageId;
  Map<String, dynamic> bookingBody() => {
    'trip_id': tripId,
    'rooms': [
      for (var i = 0; i < rooms.length; i++)
        {
          'package_id': packageIdOf(rooms[i].type),
          'room_type': rooms[i].type.slug,
          'locked_beds_count': rooms[i].lockedBeds,
          'hotels': {
            for (final city in BookingCity.values)
              if (hotelFor(city, i)?.id != null)
                city.slug: hotelFor(city, i)!.id,
          },
          'pilgrims': [
            for (final id in rooms[i].travelerIds)
              if (travelerOf(id)?.pilgrimId != null)
                {'pilgrim_id': travelerOf(id)!.pilgrimId},
          ],
        },
    ],
  };
  Future<void> _uploadDocuments() async {
    for (final traveler in travelers) {
      for (final entry in traveler.documents.entries) {
        try {
          await DioService.post(
            ApiEndpoints.uploadDocument,
            data: FormData.fromMap({
              'pilgrim_id': traveler.pilgrimId,
              'document_type': entry.key,
              'file': await MultipartFile.fromFile(entry.value.path),
            }),
          );
        } catch (error) {
          debugPrint('uploadDocument ${entry.key} error: $error');
        }
      }
    }
  }

  @override
  Future<void> close() {
    _countdown?.cancel();
    passportForm.dispose();
    return super.close();
  }
}
