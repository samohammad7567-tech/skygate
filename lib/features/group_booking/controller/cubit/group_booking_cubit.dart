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

/// Drives the nine-step "حجز مجموعة /عائلة" wizard, so the same instance is
/// handed to every screen after the booking type with `BlocProvider.value`.
///
/// Every screen reads its data from the public fields here; the states only
/// signal transitions. The wizard collects travellers first, seats them in
/// rooms, then spreads those rooms over the hotels of each city — which is the
/// order `POST app/pilgrims` then `POST app/bookings` needs them in.
class GroupBookingCubit extends Cubit<GroupBookingState> {
  GroupBookingCubit(this.tripId) : super(GroupBookingInitial());

  GroupBookingCubit get(BuildContext context) => BlocProvider.of(context);

  /// The trip being booked — it keys the route, the room prices and the
  /// hotels, and is what `POST app/bookings` seats the rooms in.
  final int tripId;

  /// The trip behind steps 6 to 9, kept by [TripService] between them.
  TripModel? trip;

  /// "الرحلة" on the summary.
  String? get tripTitle => trip?.title;

  Future<TripModel> _loadTrip({bool refresh = false}) async {
    final loaded = await TripService.trip(tripId, refresh: refresh);
    trip = loaded;
    return loaded;
  }

  /// Steps printed by the progress card.
  static const int totalSteps = 9;

  /// Hours the hold on the booking lasts.
  static const int paymentWindowHours = 24;

  /// 1-based index of the step being shown.
  int currentStep = 1;

  void goToStep(int step) {
    if (step == currentStep || step < 1 || step > totalSteps) return;
    currentStep = step;
    emit(GroupStepChanged());
  }

  // ── Steps 2 & 4 — the traveller being added ──────────────────────────────
  /// The ten passport rows, shared with the signup and individual wizards.
  final PassportForm passportForm = PassportForm();

  final List<UmrahDocumentModel> documentTypes = UmrahDocumentModel.catalogue;

  /// Files attached to the traveller currently being added.
  final Map<String, File> documents = {};

  /// [GroupTravelerModel.localId] of the adult picked in "اسم ولي الأمر".
  int? draftGuardianId;

  bool get isScanned => passportForm.isScanned;

  bool get pledgeAccepted => passportForm.pledgeAccepted;

  /// `true` while the wizard is on the group leader — step 2 rather than the
  /// step 4 "إضافة بيانات مسافر جديد" card.
  bool get isAddingLeader => travelers.isEmpty;

  /// The class the draft passport reads as, which is what decides whether
  /// "اسم ولي الأمر" has to be filled in.
  TravelerAudience get draftAudience =>
      TravelerAudience.fromBirthDate(passportForm.birthDate);

  /// Clears the draft so "إضافة مسافر" always starts on an empty passport.
  void startNewTraveler() {
    passportForm.clear();
    documents.clear();
    draftGuardianId = null;
    emit(GroupPassportFieldChanged());
  }

  /// Rebuilds the card after `PassportFieldsForm` wrote into [passportForm].
  void passportChanged() => emit(GroupPassportFieldChanged());

  void togglePledge(bool? value) {
    passportForm.pledgeAccepted = value ?? false;
    emit(GroupPassportFieldChanged());
  }

  void selectGuardian(int? localId) {
    draftGuardianId = localId;
    emit(GroupPassportFieldChanged());
  }

  /// Picks the passport photo, then hands it to [scanPassport].
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

  /// Uploads the passport photo and fills the confirmation card from the MRZ
  /// the API reads back.
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

  /// Drops the scan result so the user lands back on an empty scanner.
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
  /// Everyone on the booking, the leader first.
  final List<GroupTravelerModel> travelers = [];

  int _nextLocalId = 1;

  /// The account holder, who answers for the whole booking.
  GroupTravelerModel? get leader => travelers.isEmpty ? null : travelers.first;

  /// The adults "اسم ولي الأمر" can be picked from.
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

  /// The group is bookable once it holds at least the two travellers the
  /// "شروط و معايير الحجز" card asks for.
  bool get isGroupComplete => travelers.length >= 2;

  /// Turns the draft passport into a traveller and clears the draft.
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

  /// Drops a traveller, along with everyone travelling under them and the
  /// seats they had been given.
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

  /// Index of the ticked route card; the first one in the design.
  int selectedRouteIndex = 0;

  BookingRouteModel? get selectedRoute =>
      selectedRouteIndex < routes.length ? routes[selectedRouteIndex] : null;

  void selectRoute(int index) {
    if (selectedRouteIndex == index) return;
    selectedRouteIndex = index;
    emit(GroupRoutesLoaded());
  }

  /// The trip's itinerary as the one route it offers.
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
  /// One price sheet per room size, keyed by the size it prices.
  final Map<GroupRoomType, GroupRoomPriceModel> roomPrices = {};

  /// The rooms the group booked, in the order they were created.
  final List<GroupRoomModel> rooms = [];

  GroupRoomPriceModel? priceOf(GroupRoomType type) => roomPrices[type];

  /// Sizes offered by the package, in the order the counter sheet lists them.
  List<GroupRoomType> get offeredRoomTypes =>
      GroupRoomType.values.where(roomPrices.containsKey).toList();

  /// One price sheet per room size the trip sells.
  ///
  /// A trip may publish several packages for the same size — one per audience
  /// — and the wizard prices a room by its size alone, so the first package of
  /// each size wins and carries the `package_id` its rooms are booked against.
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

  /// How many rooms of each size the group holds, as the counter sheet opens
  /// with them.
  Map<GroupRoomType, int> get roomCounts {
    final counts = <GroupRoomType, int>{};
    for (final room in rooms) {
      counts[room.type] = (counts[room.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Applies "حدد عدد الغرف و أنواعها". Rooms already filled are kept and only
  /// the surplus of a size is dropped — from the end, so the rooms filled
  /// first survive.
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

  /// Seats [travelerIds] in the room at [index], taking them out of whatever
  /// room they were in before — a traveller sleeps in exactly one room.
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

  /// Pays for the beds left empty so a half-filled room can still be booked.
  void lockSpareBeds(int index) {
    if (index < 0 || index >= rooms.length) return;
    rooms[index].lockedBeds = rooms[index].freeBeds;
    emit(GroupRoomsChanged());
  }

  /// Who the picker offers for the room at [roomIndex]: everyone without a bed
  /// yet, plus whoever is already in this room.
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

  /// Everyone's audience in [room], in the order they were seated.
  List<TravelerAudience> audiencesIn(GroupRoomModel room) => [
    for (final id in room.travelerIds)
      travelerOf(id)?.audience ?? TravelerAudience.adult,
  ];

  /// Who sleeps in [room] and what each of them pays there — the rows the room
  /// card, the picker and the summary all print.
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

  /// How many travellers of each class sleep in [room], as the summary prints
  /// the room's header line.
  Map<TravelerAudience, int> countsIn(GroupRoomModel room) {
    final audiences = audiencesIn(room);

    return {
      for (final audience in TravelerAudience.values)
        audience: audiences.where((value) => value == audience).length,
    };
  }

  /// "المجموع النهائي" of one room.
  num totalOf(GroupRoomModel room) => room.total(audiencesIn(room));

  /// What one traveller costs in [type] given who else is already ticked —
  /// the price the picker prints beside each name.
  num priceIn(GroupRoomType type, List<int> selected, int localId) {
    final sheet = roomPrices[type];
    final audience = travelerOf(localId)?.audience;
    if (sheet == null || audience == null) return 0;

    return sheet.priceOf(
      audience,
      isSecondInfant: isSecondInfant(selected, localId),
    );
  }

  /// `true` when [localId] pays the "الرضيع الثاني" rate inside [selected] —
  /// what turns the small pink badge on next to the name.
  bool isSecondInfant(List<int> selected, int localId) {
    if (travelerOf(localId)?.audience != TravelerAudience.infant) return false;

    return selected
        .takeWhile((id) => id != localId)
        .any((id) => travelerOf(id)?.audience == TravelerAudience.infant);
  }

  /// Every room is filled or has its spare beds paid for, and nobody is left
  /// standing outside a room.
  bool get areRoomsSettled =>
      rooms.isNotEmpty &&
      rooms.every((room) => room.isSettled) &&
      travelers.every(
        (traveler) =>
            rooms.any((room) => room.travelerIds.contains(traveler.localId)),
      );

  // ── Step 8 — the rooms of each city, spread over its hotels ──────────────
  /// Hotels offered in each city, keyed by [BookingCity].
  final Map<BookingCity, List<HotelModel>> hotels = {};

  /// Nights the package stays in each city, printed next to its name.
  final Map<BookingCity, int> stayDays = {};

  /// Rooms handed to each hotel: city → hotel id → sizes.
  final Map<BookingCity, Map<int, GroupRoomAllocation>> allocations = {};

  List<HotelModel> hotelsIn(BookingCity city) => hotels[city] ?? const [];

  GroupRoomAllocation allocationOf(BookingCity city, int? hotelId) =>
      allocations[city]?[hotelId ?? -1] ?? GroupRoomAllocation();

  /// Rooms already handed to a hotel in [city].
  int allocatedIn(BookingCity city) =>
      (allocations[city]?.values ?? const <GroupRoomAllocation>[]).fold(
        0,
        (sum, allocation) => sum + allocation.total,
      );

  /// `true` once every room the group booked sleeps somewhere in [city].
  bool isCityAllocated(BookingCity city) =>
      rooms.isNotEmpty && allocatedIn(city) == rooms.length;

  /// The most rooms of each size the hotel may still take in [city] — what is
  /// left of the group's rooms once the other hotels have had their share.
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

  /// The trip's hotels in [city]. The endpoint takes no `city` filter, so the
  /// list is sorted into the two steps here.
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

  /// The hotel the room at [roomIndex] sleeps in, printed on the summary.
  ///
  /// Rooms of a size are handed to the hotels that took that size in the order
  /// both lists are already in, so the mapping stays stable between rebuilds.
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

  /// Trims allocations that outgrew the rooms after one was deleted.
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
  /// When the hold on the booking runs out.
  DateTime? paymentDeadline;

  /// Time left on the hold, refreshed once a second by [_countdown].
  Duration remaining = Duration.zero;

  Timer? _countdown;

  /// "المجموع النهائي لكل أنواع الغرف".
  num get grandTotal => rooms.fold<num>(0, (sum, room) => sum + totalOf(room));

  /// Currency the prices are printed in, taken from the first room that
  /// carries one.
  String? get currency {
    for (final room in rooms) {
      if (room.currency != null) return room.currency;
    }
    return null;
  }

  /// Opens "ملخص الحجز".
  ///
  /// Nothing is fetched: every figure on the review comes from choices the
  /// wizard already holds, and the OpenAPI document publishes no priced
  /// summary for the `trip_id` + `rooms[]` contract this flow books against.
  void prepareSummary() {
    emit(GroupSummaryLoading());
    paymentDeadline = DateTime.now().add(
      const Duration(hours: paymentWindowHours),
    );
    _startCountdown();
    emit(GroupSummaryLoaded());
  }

  /// Ticks the "أكمل الدفع خلال" clock down to the hold's expiry.
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
  /// Creates every traveller, then the booking that seats them.
  ///
  /// A failed document upload does not fail the booking — the pilgrim can
  /// retry from their profile later.
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

  /// Creates one pilgrim per traveller and keeps the id the API answers with.
  ///
  /// The list is walked in order, which is also guardian before dependant:
  /// "اسم ولي الأمر" only ever offers adults already on the booking.
  Future<void> _createPilgrims() async {
    for (final traveler in travelers) {
      if (traveler.pilgrimId != null) continue;

      final response = await DioService.post(
        ApiEndpoints.pilgrims,
        data: FormData.fromMap(
          traveler.toPilgrimJson(
            isSelf: traveler == leader,
            guardianPilgrimId: travelerOf(traveler.guardianLocalId)?.pilgrimId,
          ),
        ),
      );
      final created = response.data['data'];
      traveler.pilgrimId = created is Map ? created['id'] as int? : null;
    }
  }

  /// The package a room of [type] is booked against.
  int? packageIdOf(GroupRoomType type) => roomPrices[type]?.packageId;

  /// The `POST app/bookings` body.
  ///
  /// `trip_id` and `rooms[]` are the documented contract, each room naming the
  /// `package_id` that priced its size. The hotels the wizard collected have
  /// no home in it yet — they are sent anyway so the choice is not dropped on
  /// the floor once the backend starts accepting them.
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

  /// Uploads whatever files were attached to each traveller.
  ///
  /// `document_type_id` is documented as numeric, but the design only ever
  /// names a document and there is no lookup endpoint to translate between the
  /// two, so the slug goes out until one exists.
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
